//
//  File.swift
//  Concentration
//
//  Created by awen on 2019/3/29.
//  Copyright © 2019 awen. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards:[ConcentrationCard] = [ConcentrationCard]()
    
    private(set) var score : Int = 0
    
    
//    private var indexOfOnlyFacedUpCard:Int? {
//        get {
//            var foundCard: Int?
//            for i in cards.indices {
//                if cards[i].isFacedUp {
//                    if let _ = foundCard {
//                        return nil
//                    } else {
//                        foundCard = i
//                    }
//                }
//            }
//            return foundCard
//        }
//        set (newValue) {
//            for i in cards.indices {
//                cards[i].isFacedUp = (i == newValue)
//            }
//        }
//    }
    
    private var indexOfOnlyFacedUpCard: Int? {
        get {
            return cards.indices.filter{ cards[$0].isFacedUp }.oneAndOnly
        }
        set (newValue) {
            for i in cards.indices {
                cards[i].isFacedUp = (i == newValue)
            }
        }
    }
    
    func choose(at index: Int) {
        if !cards[index].isMatched {
            if let matchedIndex = indexOfOnlyFacedUpCard {
                if cards[matchedIndex] == cards[index] {
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFacedUp = true
            } else {
                indexOfOnlyFacedUpCard = index
            }
            
        }
    }
    
    init(numberOfCard : Int) {
        for _ in 1...numberOfCard {
            let card = ConcentrationCard()
            cards += [card, card]
        }
//        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count==1 ? first : nil
    }
}
