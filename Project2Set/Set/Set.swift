//
//  Set.swift
//  Set
//
//  Created by 颜木林 on 2019/4/21.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import Foundation

class Set {
    
    var score: Int = 0
    var maxCardsNumber: Int = 0
    
    var cardsInDeck:[Card] = [Card]()
    var cardsOnTable:[Card?] = [Card?]()
    var matchedCards:[Card] = [Card]()
    var selectedCards:[Int] = [Int]()
    
    static let allShapes = [Shape.Triangle, Shape.Rectangle, Shape.Diamond]
    static let allShadings = [Shading.Filled, Shading.Striped, Shading.Outlined]
    
    init(CardsNumber cn: Int, maxNumber max: Int) {
        for shape in Set.allShapes {
            for shading in Set.allShadings {
                for colorIdentifier in 0..<3 {
                    for number in 1...3 {
                        cardsInDeck.append(Card(shape, shading, colorIdentifier, number))
                    }
                }
            }
        }
        cardsInDeck.shuffle()
        for _ in 0..<cn {
            if let card=cardsInDeck.popLast() {
                cardsOnTable.append(card)
            }
        }
        
        score = 0
        maxCardsNumber = max
    }
    
    func choose(of index: Int) {
        print("selected: \(index)")
        
        let selectedCount = selectedCards.count
        let isSelected = selectedCards.contains(index)
        if (selectedCount == 3) {
            
            if let card1 = cardsOnTable[selectedCards[0]],
                let card2 = cardsOnTable[selectedCards[1]],
                let card3 = cardsOnTable[selectedCards[2]] {
                if card3.match(card1: card1, card2: card2) {
                    score += 2
                } else {
                    score -= 5
                }
            }
            
            for i in selectedCards {
                if let card = cardsOnTable[i] {
                    matchedCards.append(card)
                    cardsOnTable[i] = cardsInDeck.popLast()
                } else {
                    assert (false)
                }
            }
            
            deselectThreeCards()
            
            if (!isSelected) {
                selectedCards.append(index)
            }
        } else if (isSelected) {
            selectedCards.remove(at: selectedCards.firstIndex(of: index)!)
            score -= 1
        } else {
            selectedCards.append(index)
        }
        
    }
    
    func deselectThreeCards() {
        selectedCards.removeAll()
    }
    
    func dealMoreCards(_ num: Int) {
        if cardsOnTable.count == maxCardsNumber {
            return
        }
        
        for _ in 0..<num {
            if let card=cardsInDeck.popLast() {
                cardsOnTable.append(card)
            }
        }
    }
}
