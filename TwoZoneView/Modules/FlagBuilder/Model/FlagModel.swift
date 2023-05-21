//
//  FlagModel.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 20.05.2023.
//

import Foundation

struct FlagModel {
    let width: CGFloat
    let height: CGFloat
    let positionX: CGFloat
    let positionY: CGFloat
}

extension FlagModel {
    static let mock = FlagModel(width: 300, height: 300, positionX: 30, positionY: 30)
}
