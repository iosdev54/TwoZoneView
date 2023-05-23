//
//  BlueZoneRepresentable.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 23.05.2023.
//

import SwiftUI
import UIKit

struct BlueZoneRepresentable: UIViewRepresentable {
    var blueZoneEventData: (Bool) -> Void
    
    func makeUIView(context: Context) -> BlueZoneView {
        let blueZoneView = BlueZoneView()
        blueZoneView.backgroundColor = .blue
        blueZoneView.blueZoneEventData = { bool in
            blueZoneEventData(bool)
        }
        return blueZoneView
    }
    
    func updateUIView(_ uiView: BlueZoneView, context: Context) { }
}
