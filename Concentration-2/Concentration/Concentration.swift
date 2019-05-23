//
//  File.swift
//  Concentration
//
//  Created by awen on 2019/3/29.
//  Copyright © 2019 awen. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards:[Card] = [Card]()
    
    var score : Int = 0
    
    var flipCount : Int = 0
    
    var indexOfOnlyFacedUpCard:Int?
    
    func choose(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOnlyFacedUpCard, index != matchIndex {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    cards[index].isFacedUp = true
                    if cards[index].haveBeenFlipped == true {
                        score -= 1
                    } else {
                        cards[index].haveBeenFlipped = true
                    }
                }
                indexOfOnlyFacedUpCard = nil
            } else if let matchIndex = indexOfOnlyFacedUpCard, index == matchIndex {
                
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFacedUp = false
                }
                cards[index].isFacedUp = true
                indexOfOnlyFacedUpCard = index
                if cards[index].haveBeenFlipped == true {
                    score -= 1
                } else {
                    cards[index].haveBeenFlipped = true
                }
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
