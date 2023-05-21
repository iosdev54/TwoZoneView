//
//  ContentView.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 19.05.2023.
//

import SwiftUI

enum Field {
    case width
    case height
    case positionX
    case positionY
}

enum ValidationError: String, LocalizedError, Identifiable {
    case sizeError
    case positionError
    
    var id: String {
        rawValue
    }
    
    var errorDescription: String? {
        switch self {
        case .sizeError: return "Make sure you have entered the correct flag size."
        case .positionError: return "Make sure you have entered the correct flag position."
        }
    }
}

protocol TwoZoneHandler {
    func onBlueZoneEvent(isPressed: Bool)
    func onYellowZoneEvent(idx: Int, // finger index
                           x: Double, // coordinate in percentage of width (0...100)
                           y: Double // coordinate in percentage of height (0...100)
    )
}

struct FlagView: View, TwoZoneHandler {
    func onBlueZoneEvent(isPressed: Bool) {
        print("Blue zome tapped \(isPressed)")
    }
    
    func onYellowZoneEvent(idx: Int, x: Double, y: Double) {
        
    }
    
    
    let flagModel: FlagModel
    let isBlueViewHidden: Bool
    
    @State var isBlueZoneTapped = false
    
    private var cornerRadius: CGFloat {
        flagModel.width > flagModel.height ? flagModel.width / 15 : flagModel.height / 15
    }
    private var lineWidth: CGFloat {
        flagModel.width > flagModel.height ? flagModel.width / 100 : flagModel.height / 100
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Color.yellow
                    .frame(height: geometry.size.height * (isBlueViewHidden ? 1 : 0.7))
                
                if !isBlueViewHidden {
                    Rectangle()
                        .fill(.black)
                        .frame(height: lineWidth)
                    
                    Color.blue
                        .animation(.easeInOut(duration: 1))
                        .frame(height: geometry.size.height * 0.3)
                        .onChange(of: isBlueZoneTapped) { isTapped in
                            isTapped ? onBlueZoneEvent(isPressed: true) : onBlueZoneEvent(isPressed: false)
                        }
                        .gesture(blueZoneTap)
                }
            }
            .cornerRadius(cornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.black, lineWidth: lineWidth)
            }
            .animation(.default.speed(3), value: isBlueViewHidden)
        }
        .frame(width: flagModel.width, height: flagModel.height)
        .offset(x: flagModel.positionX, y: flagModel.positionY)
    }
    
    private var blueZoneTap: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                isBlueZoneTapped = true
            }
            .onEnded { _ in
                isBlueZoneTapped = false
            }
    }
    
}

struct ContentView: View {
    @State private var flagWidth = ""
    @State private var flagHeight = ""
    @State private var flagPositionX = ""
    @State private var flagPositionY = ""
    
    @State private var isHiddenBlueView = false
    @State private var flagModel: FlagModel?
    @State private var validationError: ValidationError?
    
    @State private var blueButtonPressed = false
    
    @FocusState private var keyboardIsFocused: Bool
    //    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(spacing: 10) {
            
            VStack(spacing: 10) {
                headerView(title: "Flag size")
                textField(title: "width", placeholder: "Enter width", value: $flagWidth)
                textField(title: "height", placeholder: "Enter height", value: $flagHeight)
                
                headerView(title: "Flag position")
                textField(title: "x", placeholder: "Enter X coordinate", value: $flagPositionX)
                textField(title: "y", placeholder: "Enter Y coordinate", value: $flagPositionY)
                
                Toggle("Hide the blue view", isOn: $isHiddenBlueView)
                
                drawFlagButton
            }
            .padding()
            .zIndex(1)
            
            if let flagModel {
                FlagView(flagModel: flagModel, isBlueViewHidden: isHiddenBlueView)
            }
            Spacer()
        }
        .alert(item: $validationError) { error in
            Alert(title: Text("Error!"), message: Text(error.localizedDescription), dismissButton: .cancel())
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    keyboardIsFocused = false
                }
                
            }
        }
        .onTapGesture(perform: dismissKeyboard)
    }
    
    private func headerView(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
        }
    }
    
    private func textField(title: String, placeholder: String, value: Binding<String>) -> some View {
        HStack {
            Text(title)
                .frame(width: 50)
            
            TextField(placeholder, text: value)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .focused($keyboardIsFocused)
        }
    }
    
    private var drawFlagButton: some View {
        Button(action: drawFlagPressed) {
            Text("Draw the flag")
        }
        .padding(10)
        .background(.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func drawFlagPressed() {
        keyboardIsFocused = false
        
        let sizeRange = 0...Int.max
        let positionRange = Int.min...Int.max
        
        guard let enteredWidth = Int(flagWidth.trimmingCharacters(in: .whitespacesAndNewlines)),
              sizeRange.contains(enteredWidth),
              let enteredHeight = Int(flagHeight.trimmingCharacters(in: .whitespacesAndNewlines)),
              sizeRange.contains(enteredHeight) else {
            validationError = .sizeError
            return
        }
        
        guard let enteredPositionX = Int(flagPositionX.trimmingCharacters(in: .whitespacesAndNewlines)),
              positionRange.contains(enteredPositionX),
              let enteredPositionY = Int(flagPositionY.trimmingCharacters(in: .whitespacesAndNewlines)),
              positionRange.contains(enteredPositionY) else {
            validationError = .positionError
            return
        }
        
        flagModel = FlagModel(width: CGFloat(enteredWidth), height: CGFloat(enteredHeight), positionX: CGFloat(enteredPositionX), positionY: CGFloat(enteredPositionY))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
