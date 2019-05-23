//
//  File.swift
//  Concentration
//
//  Created by awen on 2019/3/29.
//  Copyright © 2019 awen. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards:[Card] = [Card]()
    
    var score : Int = 0
    
    var flipCount : Int = 0
    
    var indexOfOnlyFacedUpCard:Int?
    
    func choose(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            cards[index].isFacedUp = true
            if let matchedIndex = indexOfOnlyFacedUpCard {
                if cards[matchedIndex].identifier == cards[index].identifier {
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                }
                indexOfOnlyFacedUpCard = nil
            } else {
                for i in cards.indices {
                    cards[i].isFacedUp = false
                }
                cards[index].isFacedUp = true
                indexOfOnlyFacedUpCard = index
            }
        }
    }
    
    init(numberOfCard : Int) {
        for _ in 1...numberOfCard {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
}
