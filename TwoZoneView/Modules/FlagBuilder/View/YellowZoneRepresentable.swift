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
    var fingersIndicesArray: ([Int]) -> Void
    
    func makeUIView(context: Context) -> YellowZoneView {
        let yellowZoneView = YellowZoneView()
        yellowZoneView.backgroundColor = .yellow
        yellowZoneView.yellowZoneEventData = { data in
            yellowZoneEventData(data)
        }
        yellowZoneView.fingerIndicesArray = { indices in
            fingersIndicesArray(indices)
        }
        return yellowZoneView
    }
    
    func updateUIView(_ uiView: YellowZoneView, context: Context) { }
}
