//
//  BlueZoneView.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 23.05.2023.
//

import SwiftUI
import UIKit

class BlueZoneView: UIView {
    var blueZoneEventData: ((Bool) -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for _ in touches {
            blueZoneEventData?(true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for _ in touches {
            blueZoneEventData?(false)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        for _ in touches {
            blueZoneEventData?(false)
        }
    }
}
