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
    
    func match(_ card1: Card, _ card2: Card) -> Bool {
        if (self.isMatched || card1.isMatched || card2.isMatched) {
            return false
        } else if (self.shape.allDiffOrAllSame(card1.shape, card2.shape) &&
            self.color.allDiffOrAllSame(card1.color, card2.color) &&
            self.shading.allDiffOrAllSame(card1.shading, card2.shading)) {
            return true
        } else {
            return false
        }
    }
    
    enum Shading {
        case filled
        case striped
        case outlined
        
        static let all = [Shading.filled, .striped, .outlined]
    }
    
    enum Shape: String {
        case triangle = "▲"
        case star = "★"
        case rectangle = "◼︎"
        
        static let all = [Shape.triangle, .star, .rectangle]
    }
    
    enum Color {
        case blue
        case red
        case brown
        
        static let all = [Color.blue, .red, .brown]
        
        var colorValue: UIColor {
            switch self {
            case .blue: return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            case .red: return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            case .brown: return #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
            }
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
