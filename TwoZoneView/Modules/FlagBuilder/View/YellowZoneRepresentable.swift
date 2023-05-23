//
//  YellowZoneRepresentable.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 23.05.2023.
//

import SwiftUI
import UIKit

struct YellowZoneRepresentable: UIViewRepresentable {
    var yellowZoneEventData: (YellowZoneDataModel) -> Void
    var fingersIndexesArray: ([Int]) -> Void
    
    func makeUIView(context: Context) -> YellowZoneView {
        let yellowZoneView = YellowZoneView()
        yellowZoneView.backgroundColor = .yellow
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
