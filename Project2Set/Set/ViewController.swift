//
//  ViewController.swift
//  Set
//
//  Created by 颜木林 on 2019/4/21.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardBtns: [UIButton]!
    @IBOutlet weak var dealMoreCardsBtn: UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBOutlet weak var scoreLab: UILabel!
    @IBOutlet weak var remainCountLab: UILabel!
    
    lazy var game:Set = Set(CardsNumber: self.cardBtns.count / 2, maxNumber: self.cardBtns.count)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCards()
        updateBtnState()
    }
    
    func updateCards() {
        for index in cardBtns.indices {
            cardBtns[index].layer.cornerRadius = 5.0
            cardBtns[index].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cardBtns[index].layer.borderWidth = 5.0
            if index < game.cardsOnTable.count, let card = game.cardsOnTable[index] {
                cardBtns[index].setAttributedTitle(getCardContentWith(Shape: card.shape, shading: card.shading, colorIdentifier: card.colorIdentifier, number: card.number), for: UIControl.State.normal)
                cardBtns[index].titleLabel?.numberOfLines = card.number
                cardBtns[index].backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.8941176471, blue: 0.8392156863, alpha: 1)
                cardBtns[index].isEnabled = true
            } else {
                cardBtns[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
                cardBtns[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                cardBtns[index].isEnabled = false
            }
        }
        
        var borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        if game.selectedCards.count == 3 {
            if let card1 = game.cardsOnTable[game.selectedCards[0]],
                let card2 = game.cardsOnTable[game.selectedCards[1]],
                let card3 = game.cardsOnTable[game.selectedCards[2]]{
                if card3.match(card1: card1, card2: card2) {
                    borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                } else {
                    borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                }
            }
        }
        for index in game.selectedCards {
            cardBtns[index].layer.borderColor = borderColor.cgColor
        }
    }
    
    func updateScore() {
        scoreLab.text = "Score: \(game.score)"
    }
    func updateRemain() {
        remainCountLab.text = "Remain: \(game.cardsInDeck.count)"
        if game.cardsInDeck.count == 0 {
            dealMoreCardsBtn.isEnabled = false
        }
    }
    
    func updateBtnState() {
        helpBtn.isEnabled = true
        if (game.cardsInDeck.count > 0) {
            dealMoreCardsBtn.isEnabled = true
        }
    }

    @IBAction func clickHelp(_ sender: UIButton) {
        if game.selectedCards.count == 3 {
            cardBtns[game.selectedCards[0]].sendActions(for: UIControl.Event.touchUpInside)
        }
        let tableCards = game.cardsOnTable
        for i in 0..<tableCards.count {
            for j in i+1..<tableCards.count {
                for k in j+1..<tableCards.count {
                    if let card1 = tableCards[i], let card2 = tableCards[j], let card3 = tableCards[k] {
                        if (card3.match(card1: card1, card2: card2)) {
                            cardBtns[i].sendActions(for: UIControl.Event.touchUpInside);
                            cardBtns[j].sendActions(for: UIControl.Event.touchUpInside);
                            cardBtns[k].sendActions(for: UIControl.Event.touchUpInside);
                            return
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func clickNewGame(_ sender: UIButton) {
        game = Set(CardsNumber: self.cardBtns.count / 2, maxNumber: self.cardBtns.count)
        updateCards()
        updateScore()
        updateBtnState()
        updateRemain()
    }
    @IBAction func clickDeal3MoreCards(_ sender: UIButton) {
        game.dealMoreCards(3)
        updateCards()
        updateBtnState()
        updateRemain()
    }
    
    @IBAction func clickCard(_ sender: UIButton) {
        let cardIdx = cardBtns.firstIndex(of: (sender))!
        game.choose(of: cardIdx)
        updateCards()
        updateScore()
        updateBtnState()
        updateRemain()
    }
    
    let colors:[UIColor] = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    let strokeWidth = 5.0
    
    func getCardContentWith(Shape shape: Shape, shading: Shading, colorIdentifier: Int, number: Int) -> NSAttributedString {
        let shapeText:String
        switch (shape) {
        case .Triangle: shapeText = "▲"
        case .Rectangle: shapeText = "◼︎"
        case .Diamond: shapeText = "◆"
        }
        let plainText = [String](repeating: shapeText, count: number).joined(separator: "\n")
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.strokeColor] = colors[colorIdentifier]

        switch shading {
        case .Outlined: attributes[.strokeWidth] = strokeWidth
        case .Filled:
            attributes[.strokeWidth] = -strokeWidth
            attributes[.foregroundColor] = colors[colorIdentifier]
        case .Striped:
            attributes[.strokeWidth] = -strokeWidth
            attributes[.foregroundColor] = colors[colorIdentifier].withAlphaComponent(0.3)
        }
        
        let attributedText = NSAttributedString(string: plainText, attributes: attributes)
        
        return attributedText
    }

}

