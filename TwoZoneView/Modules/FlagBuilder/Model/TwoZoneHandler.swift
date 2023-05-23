//
//  TwoZoneHandler.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 21.05.2023.
//

import Foundation

protocol TwoZoneHandler {
    func onBlueZoneEvent(isPressed: Bool)
    func onYellowZoneEvent(idx: Int, // finger index
                           x: Double, // coordinate in percentage of width (0...100)
                           y: Double // coordinate in percentage of height (0...100)
    )
}

extension TwoZoneHandler {
    func onBlueZoneEvent(isPressed: Bool) {
        print("Blue zone tapped - \(isPressed.description)")
    }
    
    func onYellowZoneEvent(idx: Int, x: Double, y: Double) {
        print("Yellow zone tapped, finger index \(idx), with coordinate in percentage of (width : height) (\(x) : \(y))")
    }
}
