//
//  FlagBuilderView.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 21.05.2023.
//

import SwiftUI

struct FlagBuilderView: View {
    
    enum Field {
        case width
        case height
        case positionX
        case positionY
    }
    
    @StateObject private var viewModel = FlagBuilderViewModel()
    
    @State private var isBlueViewHidden = false
    
    @State private var isBlueZoneTapped = false
    @State private var isYellowZoneTapped = false
    
    @FocusState private var focusedField: Field?
    @FocusState private var keyboardIsFocused: Bool
    
    @State private var isOutputShown = false
    @State private var outputYellowZoneString = "[]"
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .onTapGesture(perform: dismissKeyboard)
            
            VStack(spacing: 10) {
                
                VStack(spacing: 10) {
                    headerView(title: "Flag size")
                    textField(title: "width", placeholder: "Enter width", value: $viewModel.flagWidth, focusedField: .width, submitLabel: .next)
                    textField(title: "height", placeholder: "Enter height", value: $viewModel.flagHeight, focusedField: .height, submitLabel: .next)
                    
                    headerView(title: "Flag position")
                        .padding(.top, 10)
                    textField(title: "x", placeholder: "Enter X coordinate", value: $viewModel.flagPositionX, focusedField: .positionX, submitLabel: .next)
                    textField(title: "y", placeholder: "Enter Y coordinate", value: $viewModel.flagPositionY, focusedField: .positionY, submitLabel: .done)
                    
                    Toggle("Hide the blue view", isOn: $isBlueViewHidden)
                        .padding(.top, 10)
                    
                    drawFlagButton
                        .padding(.top, 10)
                }
                .padding()
                .zIndex(1)
                
                if let flagModel = viewModel.flagModel {
                    FlagView(flagModel: flagModel, isBlueViewHidden: isBlueViewHidden, isBlueZoneTapped: $isBlueZoneTapped, isYellowZoneTapped: $isYellowZoneTapped, outputYellowZone: $outputYellowZoneString)
                }
                
                Spacer()
                
                output
                    .animation(.default.speed(2), value: isBlueViewHidden)
            }
        }
        .alert(item: $viewModel.validationError) { error in
            Alert(title: Text("Error!"), message: Text(error.localizedDescription), dismissButton: .cancel())
        }
        .onSubmit {
            switch focusedField {
            case .width:
                focusedField = .height
            case .height:
                focusedField = .positionX
            case .positionX:
                focusedField = .positionY
            default:
                keyboardIsFocused = false
                drawFlagPressed()
            }
        }
    }
    
    private func headerView(title: String) -> some View {
        HStack {
            Text(title)
                .font(.title3)
            
            Spacer()
        }
    }
    
    private func textField(title: String, placeholder: String, value: Binding<String>, focusedField: Field, submitLabel: SubmitLabel) -> some View {
        HStack {
            Text(title)
                .frame(width: 50)
            
            TextField(placeholder, text: value)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .focused($focusedField, equals: focusedField)
                .focused($keyboardIsFocused)
                .submitLabel(submitLabel)
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
        .opacity(viewModel.isDrawButtonEnabled ? 1 : 0.5)
        .disabled(!viewModel.isDrawButtonEnabled)
    }
    
    private func dismissKeyboard() {
        keyboardIsFocused = false
    }
    
    private func drawFlagPressed() {
        dismissKeyboard()
        isOutputShown = true
        viewModel.drawFlagPressed()
    }
    
    @ViewBuilder private var output: some View {
        if isOutputShown {
            VStack {
                Text("Yellow zone indexes - \(outputYellowZoneString)")
                
                if !isBlueViewHidden {
                    Text("Blue zone is tapped - \(isBlueZoneTapped.description)")
                }
            }
            .padding()
            .zIndex(1)
        }
    }
}

struct FlagBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        FlagBuilderView()
    }
}
