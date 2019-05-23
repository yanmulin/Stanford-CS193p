//
//  Card.swift
//  Concentration
//
//  Created by awen on 2019/3/29.
//  Copyright © 2019 awen. All rights reserved.
//

import Foundation

struct Card {
    var identifier: Int
    var isMatched = false
    var isFacedUp = false
    var haveBeenFlipped = false
    
    static var maxIdentifier = 0
    
    static func getUniqueIdentifier() -> Int {
        maxIdentifier += 1
        return maxIdentifier
    }
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }
    
}
