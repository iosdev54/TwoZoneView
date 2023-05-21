//
//  FlagBuilderView.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 21.05.2023.
//

import SwiftUI

struct FlagBuilderView: View {
    @StateObject private var viewModel = FlagBuilderViewModel()
    
    @State private var isBlueViewHidden = false
    
    @State private var isBlueZoneTapped = false
    @State private var isYellowZoneTapped = false
    
    @FocusState private var keyboardIsFocused: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .onTapGesture(perform: dismissKeyboard)
            
            VStack(spacing: 10) {
                
                VStack(spacing: 10) {
                    headerView(title: "Flag size")
                    textField(title: "width", placeholder: "Enter width", value: $viewModel.flagWidth)
                    textField(title: "height", placeholder: "Enter height", value: $viewModel.flagHeight)
                    
                    headerView(title: "Flag position")
                        .padding(.top, 10)
                    textField(title: "x", placeholder: "Enter X coordinate", value: $viewModel.flagPositionX)
                    textField(title: "y", placeholder: "Enter Y coordinate", value: $viewModel.flagPositionY)
                    
                    Toggle("Hide the blue view", isOn: $isBlueViewHidden)
                        .padding(.top, 10)
                    
                    drawFlagButton
                        .padding(.top, 10)
                }
                .padding()
                .zIndex(1)
                
                if let flagModel = viewModel.flagModel {
                    FlagView(flagModel: flagModel, isBlueViewHidden: isBlueViewHidden, isBlueZoneTapped: $isBlueZoneTapped, isYellowZoneTapped: $isYellowZoneTapped)
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.keyboard)
        .alert(item: $viewModel.validationError) { error in
            Alert(title: Text("Error!"), message: Text(error.localizedDescription), dismissButton: .cancel())
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("-") {
                    
                }
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
                
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
    
    private func textField(title: String, placeholder: String, value: Binding<String>) -> some View {
        HStack {
            Text(title)
                .frame(width: 50)
            
            TextField(placeholder, text: value)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
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
        .opacity(viewModel.isDrawButtonEnabled ? 1 : 0.5)
        .disabled(!viewModel.isDrawButtonEnabled)
    }
    
    private func dismissKeyboard() {
        keyboardIsFocused = false
    }
    
    private func drawFlagPressed() {
        dismissKeyboard()
        viewModel.drawFlagPressed()
    }
}

struct FlagBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        FlagBuilderView()
    }
}
