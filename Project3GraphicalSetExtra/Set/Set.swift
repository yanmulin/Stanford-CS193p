//
//  Set.swift
//  Set
//
//  Created by 颜木林 on 2019/4/22.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import Foundation

class Set {
    
    private(set) var deckCards: [Card] = [Card]()
    private(set) var playedCards: [Card] = [Card]()
    
    var selectedCardIndices: [Int] {
        return playedCards.indices.filter{ !playedCards[$0].isMatched && playedCards[$0].isSelected }
    }
    
    var isThreeCardsSelectedAndMatched: Bool {
        if selectedCardIndices.count == 3 {
            let card1 = playedCards[selectedCardIndices[0]]
            let card2 = playedCards[selectedCardIndices[1]]
            let card3 = playedCards[selectedCardIndices[2]]
            if card1.match(card2, card3) {
                return true
            }
        }
        return false
    }
    var score = 0
    
    func choose(at index: Int) {
        if !playedCards[index].isMatched {
            let isSelected = playedCards[index].isSelected
            if isThreeCardsSelectedAndMatched {
                selectedCardIndices.forEach { playedCards[$0].isMatched = true }
                deal3MoreCards()
                score += 2
            } else if selectedCardIndices.count == 3 {
                selectedCardIndices.forEach { playedCards[$0].isSelected = false }
                score -= 5
            } else {
                playedCards[index].isSelected = !isSelected
            }
        }
    }
    
    func deal3MoreCards() {
        if deckCards.count > 0 {
            var cardToDeal = 3
            let matchedCardIndices = playedCards.indices.filter { playedCards[$0].isMatched }
            matchedCardIndices.forEach {
                playedCards[$0] = deckCards.popLast()!
                cardToDeal -= 1
            }
            for _ in 0..<cardToDeal {
                playedCards.append(deckCards.popLast()!)
            }
        }
    }
    
    func reshufflePlayingCards() {
        playedCards.shuffle()
    }
    
    init() {
        for shape in Card.Shape.all {
            for color in Card.Color.all {
                for number in 1...3 {
                    for shading in Card.Shading.all {
                        deckCards.append(Card(shape: shape, shading: shading, color: color, number: number, isMatched: false, isSelected: false))
                    }
                }
            }
        }
        
        // shuffle...
//        deckCards.shuffle()
        
        for _ in 0..<12 {
            playedCards.append(deckCards.popLast()!)
        }
    }
}

