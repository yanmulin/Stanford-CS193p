//
//  Card.swift
//  Set
//
//  Created by 颜木林 on 2019/4/22.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import Foundation
import UIKit

struct Card {
    var shape: Shape
    var shading: Shading
    var color: Color
    var number: Int
    
    var isMatched: Bool
    var isSelected: Bool
    
    enum Shading {
        case filled
        case stripped
        case outlined
        
        static let all = [Shading.filled, .stripped, .outlined]
    }
    
    enum Shape {
        case squiggle
        case diamond
        case oval
        
        static let all = [Shape.squiggle, .diamond, .oval]
    }
    
    enum Color {
        case red
        case green
        case purple
        
        static let all = [Color.red, .green, .purple]
        var rawValue: UIColor {
            switch self {
            case .red: return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case .green: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .purple: return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }
        }
    }
    
}

extension Card {
    
    func match(_ card1: Card, _ card2: Card) -> Bool {
        if (shape.allDiffOrAllSame(card1.shape, card2.shape) &&
            color.allDiffOrAllSame(card1.color, card2.color) &&
            shading.allDiffOrAllSame(card1.shading, card2.shading) &&
            number.allDiffOrAllSame(card1.number, card2.number)) {
            return true
        } else {
            return false
        }
    }
}

extension Equatable {
    func allDiffOrAllSame (_ x: Self, _ y: Self) -> Bool {
        let allSame = self == x && x == y
        if (!allSame && (self == x || self == y || x == y)) {
            return false
        }
        return true
    }
}
