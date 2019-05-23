//
//  ViewController.swift
//  Set
//
//  Created by 颜木林 on 2019/4/22.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardBtns: [UIButton]!
    @IBOutlet weak var dealBtn: UIButton!
    @IBOutlet weak var scoreLab: UILabel!
    @IBOutlet weak var timerLab: UILabel!
    
    var game = Set()
    var score = 0
    var computerScore = 0
    var isPlayerTurn = true
    
    var timer: Timer = Timer()
    var seconds = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for btn in cardBtns {
            btn.layer.cornerRadius = 5.0
            btn.layer.borderWidth = 5.0
            btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        }
        updateCards()
        updateSecons()
        updateScore()
        updateDealBtn()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.timeManagement() }
    }
    
    private func timeManagement() {
        if !game.isGameOver {
            seconds -= 1
            if seconds <= 0 {seconds = 10
                let _ = game.makeTurn()
                computerTurn()
            }
        } else {
            timer.invalidate()
        }
        updateSecons()
    }
    
    private func computerTurn() {
        if game.deckCards.count > 0 {
            game.clearSelection()
        }
        if let (i, j, k) = game.setInPlayingCards {
            game.choose(at: i)
            game.choose(at: j)
            game.choose(at: k)
            computerScore += game.makeTurn()
        } else {
            computerScore += game.deal3MoreCards()
        }
        updateDealBtn()
        updateCards()
        updateScore()
        seconds = 10
    }
    
    // MARK: Update display
    private func updateSecons() {
        var computerEmoji: String
        if game.isGameOver {
            if score > computerScore {
                computerEmoji = "😢"
            } else {
                computerEmoji = "😂"
            }
        } else if seconds > 5 {
            computerEmoji = "🤔"
        } else {
            computerEmoji = "😁"
        }
        timerLab.text = "\(seconds)\(computerEmoji)"
    }
    
    private func updateCards() {
        for i in cardBtns.indices {
            if i < game.playedCards.count && !game.playedCards[i].isMatched {
                let card = game.playedCards[i]
                cardBtns[i].setAttributedTitle(getAttributedString(for: card), for: UIControl.State.normal)
                cardBtns[i].backgroundColor = #colorLiteral(red: 0.9796741605, green: 0.9149391651, blue: 0.8697664142, alpha: 1)
                cardBtns[i].isEnabled = true
                cardBtns[i].titleLabel?.numberOfLines = card.number
                if game.playedCards[i].isSelected {
                    cardBtns[i].layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
                } else {
                    cardBtns[i].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
                }
            } else {
                cardBtns[i].setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
                cardBtns[i].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                cardBtns[i].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor
                cardBtns[i].isEnabled = false
            }
        }
        
        if game.selectedCardIndices.count == 3 {
            let borderColor: CGColor = (game.isThreeCardsSelectedAndMatched ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)).cgColor
            game.selectedCardIndices.forEach{ cardBtns[$0].layer.borderColor = borderColor }
        }
    }
    
    private func updateScore() {
        scoreLab.text = "Score: \(score)/\(computerScore)"
    }
    
    private func updateDealBtn() {
        dealBtn.isEnabled = (cardBtns.count > game.playedCards.count &&  game.deckCards.count > 0)
    }
    
    
    // MARK: Actions
    
    @IBAction  func clickCard(_ sender: UIButton) {
        if let index = cardBtns.firstIndex(of: sender) {
            game.choose(at: index)
            updateCards()
            updateDealBtn()
            updateScore()
            
            if game.isThreeCardsSelectedAndMatched {
                score += game.makeTurn()
                computerTurn()
            }
        }
    }
    @IBAction func clickNewGame(_ sender: UIButton) {
        game = Set()
        score = 0
        computerScore = 0
        dealBtn.isEnabled = true
        updateCards()
        updateScore()
        updateDealBtn()
    }
    @IBAction func clickDealMoreCards(_ sender: UIButton) {
        if game.playedCards.count < cardBtns.count {
            score += game.deal3MoreCards()
            computerTurn()
        }
    }
    @IBAction func clickHelp(_ sender: Any) {
        if game.selectedCardIndices.count > 0 {
            game.clearSelection()
        }
        
        if let (i, j, k) = game.setInPlayingCards {
            cardBtns[i].sendActions(for: UIControl.Event.touchUpInside)
            cardBtns[j].sendActions(for: UIControl.Event.touchUpInside)
            cardBtns[k].sendActions(for: UIControl.Event.touchUpInside)
            return
        }
    }
}

extension ViewController {
    private func getAttributedString(for card: Card) -> NSAttributedString {
        let content = [String](repeating: card.shape.rawValue, count: card.number).joined(separator: "\n")
        
        var attributes: [NSAttributedString.Key: Any] = [.strokeColor: card.color.colorValue]
        
        switch (card.shading) {
        case .filled:
            attributes[.strokeWidth] = -5.0
            attributes[.foregroundColor] = card.color.colorValue
        case .striped:
            attributes[.strokeWidth] = -5.0
            attributes[.foregroundColor] = card.color.colorValue.withAlphaComponent(0.15)
        case .outlined:
            attributes[.strokeWidth] = 5.0
        }
        
        let attributedString = NSAttributedString(string: content, attributes: attributes)
        
        return attributedString
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

