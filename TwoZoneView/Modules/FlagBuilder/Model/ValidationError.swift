//
//  ValidationError.swift
//  TwoZoneView
//
//  Created by Dmytro Grytsenko on 21.05.2023.
//

import Foundation

enum ValidationError: String, LocalizedError, Identifiable {
    case sizeError
    case positionError
    
    var id: String {
        rawValue
    }
    
    var errorDescription: String? {
        switch self {
        case .sizeError: return "Make sure you have entered the correct flag size."
        case .positionError: return "Make sure you have entered the correct flag position."
        }
    }
}
