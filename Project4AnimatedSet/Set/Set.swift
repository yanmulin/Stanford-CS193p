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
    private(set) var discardedCards: [Card] = [Card]()
    
    var selectedCardIndices: [Int] {
        return playedCards.indices.filter{ playedCards[$0].isSelected }
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
            if selectedCardIndices.count == 3 {
                selectedCardIndices.forEach { playedCards[$0].isSelected = false }
            }
            playedCards[index].isSelected = !playedCards[index].isSelected
            if isThreeCardsSelectedAndMatched {
                selectedCardIndices.forEach { playedCards[$0].isMatched = true }
                score += 2
            }
        }
    }
    
    func deal3MoreCards() -> [Int] {
        var result = [Int]()
        if deckCards.count > 0 {
            var cardToDeal = 3
            let matchedCardIndices = playedCards.indices.filter { playedCards[$0].isMatched }
            matchedCardIndices.forEach {
                discardedCards.append(playedCards[$0])
                playedCards[$0] = deckCards.popLast()!
                result.append($0)
                cardToDeal -= 1
            }
            for _ in 0..<cardToDeal {
                let card = deckCards.popLast()!
                playedCards.append(card)
                result.append(playedCards.count-1)
            }
        }
        return result
    }
    
    func findASetOnPlayingCards() -> (Int, Int, Int)? {
        for i in 0..<playedCards.count-2 {
            for j in i+1..<playedCards.count-1 {
                for k in j+1..<playedCards.count {
                    let card1 = playedCards[i]
                    let card2 = playedCards[j]
                    let card3 = playedCards[k]
                    if card1.isMatched || card2.isMatched || card3.isMatched {
                        continue
                    } else if card1.match(card2, card3) {
                        return (i, j, k)
                    }
                }
            }
        }
        return nil
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

