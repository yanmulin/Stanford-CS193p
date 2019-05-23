//
//  ViewController.swift
//  Concentration
//
//  Created by awen on 2019/3/29.
//  Copyright © 2019 awen. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    var numberOfCards: Int {
        get {
            return (self.buttons.count + 1) / 2
        }
    }
    
    private lazy var game = Concentration(numberOfCard: numberOfCards)
    
    @IBOutlet private var buttons: [UIButton]!
    
    @IBOutlet private weak var flipCountLab: UILabel! {
        didSet {
            updateFlipCount()
        }
    }
    
    private(set) var flipCount : Int = 0 {
        didSet {
            updateFlipCount()
        }
    }
    
    @IBAction private func clickNewGame(_ sender: UIButton) {
        game = Concentration(numberOfCard: (self.buttons.count + 1) / 2)
        updateButtons()
    }
    
    @IBAction private func clickButton(_ sender: UIButton) {
        if let numberOfButton = buttons.firstIndex(of: sender) {
            game.choose(at: numberOfButton)
            updateButtons()
        }
    }
    
    private func updateButtons() {
        if buttons != nil {
            flipCount += 1
            for idx in game.cards.indices {
                if game.cards[idx].isMatched == true {
                    buttons[idx].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    buttons[idx].setTitle("", for: UIControl.State.normal)
                } else if game.cards[idx].isFacedUp == true {
                    buttons[idx].backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    buttons[idx].setTitle(emoji(for: game.cards[idx]), for: UIControl.State.normal)
                } else {
                    buttons[idx].backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                    buttons[idx].setTitle("", for: UIControl.State.normal)
                }
            }
        }
    }
    
    private func updateFlipCount() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ] 
        let attributedString = NSAttributedString(string: "FlipCount:\(flipCount)", attributes: attributes)
        flipCountLab.attributedText = attributedString
    }
    
    var theme: String? {
        didSet {
            emojiChoice = theme ?? ""
            emoji = [:]
            updateButtons()
        }
    }
//    private var emojiChoice:[String] = ["😈", "👻", "🎃", "🙀", "🤢", "😱", "👽", "☠️", "🍭", "👺"]
    private var emojiChoice:String = "😈👻🎃🙀🤢😱👽☠️🍭👺"
    
    private var emoji = [ConcentrationCard:String]()

    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil {
            let randomEmojiStringIndex = emojiChoice.index(emojiChoice.startIndex, offsetBy: emojiChoice.count.arc4random)
            emoji[card] = String(emojiChoice.remove(at: randomEmojiStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


