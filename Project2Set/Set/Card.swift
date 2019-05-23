//
//  Card.swift
//  Set
//
//  Created by 颜木林 on 2019/4/21.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import Foundation

enum Shape {
    case Triangle
    case Rectangle
    case Diamond
}

enum Shading {
    case Filled
    case Striped
    case Outlined
}

class Card : Equatable{
    
    var shape: Shape = .Triangle
    var shading: Shading = .Filled
    var colorIdentifier: Int = 0
    var number: Int = 0
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.shape == rhs.shape &&
            lhs.colorIdentifier == rhs.colorIdentifier &&
            lhs.number == rhs.number)
    }
    
    init(_ shape:Shape, _ shading:Shading, _ colorIdentifier: Int, _ number: Int) {
        self.shape = shape
        self.shading = shading
        self.colorIdentifier = colorIdentifier
        self.number = number
    }
    
    func match(card1: Card, card2: Card) -> Bool {
        let sameShape = (shape == card1.shape && shape == card2.shape)
        if (!sameShape && (shape == card1.shape || shape == card2.shape || card1.shape == card2.shape)) {
            return false
        }
        
        let sameShading = (shading == card1.shading && shading == card2.shading)
        if (!sameShading && (shading == card1.shading || shading == card2.shading || card1.shading == card2.shading)) {
            return false
        }
        
        let sameColorIdentifier = (colorIdentifier == card1.colorIdentifier && colorIdentifier == card2.colorIdentifier)
        if (!sameColorIdentifier && (colorIdentifier == card1.colorIdentifier || colorIdentifier == card2.colorIdentifier || card1.colorIdentifier == card2.colorIdentifier)) {
            return false
        }
        
        let sameNumber = (number == card1.number && number == card2.number)
        if (!sameNumber && (number == card1.number || number == card2.number || card1.number == card2.number)) {
            return false
        }
        
        return true
        
        
    }
}
