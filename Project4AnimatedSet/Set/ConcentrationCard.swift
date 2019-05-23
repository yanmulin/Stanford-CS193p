//
//  Card.swift
//  Concentration
//
//  Created by awen on 2019/3/29.
//  Copyright © 2019 awen. All rights reserved.
//

import Foundation

struct ConcentrationCard: Hashable {
    private var identifier: Int
    var isMatched = false
    var isFacedUp = false
    
    var hasValue: Int {
        return identifier
    }
    
    static func ==(lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var maxIdentifier = 0
    
    private static func getUniqueIdentifier() -> Int {
        maxIdentifier += 1
        return maxIdentifier
    }
    
    init() {
        identifier = ConcentrationCard.getUniqueIdentifier()
    }
    
}
