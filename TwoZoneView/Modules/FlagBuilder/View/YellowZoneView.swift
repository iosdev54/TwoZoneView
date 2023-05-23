//
//  YellowZoneView.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 22.05.2023.
//

import SwiftUI
import UIKit

struct YellowZoneRepresentable: UIViewRepresentable {
    
    var yellowZoneEventData: (YellowZoneDataModel) -> Void
    var fingersIndexesArray: ([Int]) -> Void
    
    func makeUIView(context: Context) -> YellowZoneView {
        let yellowZoneView = YellowZoneView()
        yellowZoneView.yellowZoneEventData = { data in
            yellowZoneEventData(data)
        }
        yellowZoneView.fingersIndexesArray = { indexes in
            fingersIndexesArray(indexes)
        }
        return yellowZoneView
    }
    
    func updateUIView(_ uiView: YellowZoneView, context: Context) { }
}

class YellowZoneView: UIView {
    
    var fingerIndices = [UITouch: Int]()
    var inactiveFingerIndices = [Int]()
    
    var fingersIndexesArray: (([Int]) -> Void)?
    var yellowZoneEventData: ((YellowZoneDataModel) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isMultipleTouchEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            handleTap(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            handleUntap(touch)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        for touch in touches {
            handleUntap(touch)
        }
    }
    
    private func handleTap(_ touch: UITouch) {
        guard let view = superview else { return }
        let touchLocation = touch.location(in: view)
        
        if fingerIndices[touch] == nil {
            inactiveFingerIndices.sort()
            if let inactiveIndex = inactiveFingerIndices.first {
                inactiveFingerIndices.removeFirst()
                fingerIndices[touch] = inactiveIndex
            } else {
                let newIndex = fingerIndices.count
                fingerIndices[touch] = newIndex
            }
        }
        
        let fingerIndex = fingerIndices[touch] ?? 0
        fingersIndexesArray?(fingerIndices.values.sorted())
        
        let position = CGPoint(
            x: (touchLocation.x / view.bounds.width) * 100,
            y: (touchLocation.y / view.bounds.height) * 100
        )
        
        let yellowZoneData = YellowZoneDataModel(fingerIndex: fingerIndex, xPercentage: position.x, yPercentage: position.y)
        yellowZoneEventData?(yellowZoneData)
    }
    
    private func handleUntap(_ touch: UITouch) {
        if let fingerIndex = fingerIndices[touch] {
            fingerIndices.removeValue(forKey: touch)
            inactiveFingerIndices.append(fingerIndex)
        }
        
        fingersIndexesArray?(fingerIndices.values.sorted())
    }
    
}

