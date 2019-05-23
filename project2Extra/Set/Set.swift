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
    
    private var lastRecord = Date()

    var selectedCardIndices: [Int] {
        return playedCards.indices.filter { !playedCards[$0].isMatched && playedCards[$0].isSelected }
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
    var setInPlayingCards: (Int, Int, Int)? {
        for i in 0..<playedCards.count-2 {
            for j in i+1..<playedCards.count-1 {
                for k in j+1..<playedCards.count {
                    let card1 = playedCards[i]
                    let card2 = playedCards[j]
                    let card3 = playedCards[k]
                    if card1.match(card2, card3) {
                        return (i, j, k)
                    }
                }
            }
        }
        return nil
    }
    var isGameOver: Bool {
        return deckCards.count == 0 && setInPlayingCards == nil
    }
    
    func choose(at index: Int) {
        if !playedCards[index].isMatched {
            if isThreeCardsSelectedAndMatched {
                if deckCards.count > 3 {
                    selectedCardIndices.forEach { playedCards[$0] = deckCards.popLast()! }
                } else {
                    selectedCardIndices.forEach { playedCards[$0].isMatched = true }
                }
            } else if selectedCardIndices.count == 3 {
                selectedCardIndices.forEach { playedCards[$0].isSelected = false}
            } else {
                playedCards[index].isSelected = !playedCards[index].isSelected
            }
        }
    }
    
    func deal3MoreCards() -> Int {
        var scoreChange: Int = 0
        if deckCards.count >= 3 {
            if let _ = setInPlayingCards {
                scoreChange = -1
            }
            for _ in 0..<3 {
                playedCards.append(deckCards.popLast()!)
            }
        }
        playedCards.indices.forEach { playedCards[$0].isSelected = false }
        lastRecord = Date()
        return scoreChange
    }
    
    func makeTurn() -> Int {
        let timeInterval = Date().timeIntervalSince(lastRecord)
        lastRecord = Date()
        var scoreChange = 0
        if selectedCardIndices.count == 3 {
            if isThreeCardsSelectedAndMatched {
                scoreChange = timeInterval >= 8 ? 1 : 8 - Int(timeInterval)
            } else {
                scoreChange = -8
            }
        }
        return scoreChange
    }
    
    func clearSelection() {
        if isThreeCardsSelectedAndMatched {
            if deckCards.count > 3 {
                selectedCardIndices.forEach { playedCards[$0] = deckCards.popLast()! }
            } else {
                selectedCardIndices.forEach { playedCards[$0].isMatched = true }
            }
        } else if selectedCardIndices.count == 3 {
            selectedCardIndices.forEach { playedCards[$0].isSelected = false}
        }
        playedCards.indices.forEach { playedCards[$0].isSelected = false }
    }
    
    init() {
        for shape in Card.Shape.all {
            for color in Card.Color.all {
                for number in 1...3 {
                    for shading in Card.Shading.all {
                        let card = Card(shape: shape, shading: shading, color: color, number: number, isMatched: false, isSelected: false)
                        deckCards.append(card)
                    }
                }
            }
        }
        
        // shuffle...
        deckCards.shuffle()
        
        for _ in 0..<12 {
            playedCards.append(deckCards.popLast()!)
        }
    }
}

