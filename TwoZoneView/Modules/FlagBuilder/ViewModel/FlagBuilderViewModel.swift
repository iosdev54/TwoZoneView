//
//  FlagBuilderViewModel.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 21.05.2023.
//

import Combine
import Foundation

class FlagBuilderViewModel: ObservableObject {
    @Published var flagWidth = ""
    @Published var flagHeight = ""
    @Published var flagPositionX = ""
    @Published var flagPositionY = ""
    
    @Published var isDrawButtonEnabled = false
    
    @Published var flagModel: FlagModel?
    @Published var validationError: ValidationError?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setUpBindings()
    }
    
    private func setUpBindings() {
        Publishers.CombineLatest4($flagWidth, $flagHeight, $flagPositionX, $flagPositionY)
            .map { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && !$3.isEmpty }
            .sink { [weak self] in
                self?.isDrawButtonEnabled = $0
            }
            .store(in: &subscriptions)
    }
    
    func drawFlagPressed() {
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
