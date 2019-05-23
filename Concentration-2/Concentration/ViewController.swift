//
//  ViewController.swift
//  Concentration
//
//  Created by awen on 2019/3/29.
//  Copyright © 2019 awen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var flipCountLab: UILabel!
    
    @IBOutlet weak var scoreLab: UILabel!
    
    lazy var game = Concentration(numberOfCard: (self.buttons.count + 1) / 2)
    
    
    @IBAction func clickNewGame(_ sender: UIButton) {
        game = Concentration(numberOfCard: (self.buttons.count + 1) / 2)
        updateButtons()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        if let numberOfButton = buttons.firstIndex(of: sender) {
            game.choose(at: numberOfButton)
            updateButtons()
            updateSocre()
            updateFlipCount()
        }
    }
    
    func updateButtons() {
        for idx in game.cards.indices {
            if game.cards[idx].isMatched == true {
                buttons[idx].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                buttons[idx].setTitle("", for: UIControl.State.normal)
            } else if game.cards[idx].isFacedUp == true {
                buttons[idx].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                buttons[idx].setTitle(emoji(for: game.cards[idx]), for: UIControl.State.normal)
            } else {
                buttons[idx].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                buttons[idx].setTitle("", for: UIControl.State.normal)
            }
        }
    }
    
    func updateSocre() {
        scoreLab.text = "Score:\(game.score)"
    }
    
    func updateFlipCount() {
        flipCountLab.text = "FlipCount:\(game.flipCount)"
    }
    
    var emojiTheme:[String]?
    var emoji:[Int:String] = [Int:String]()
    
    static func getRandomTheme() -> [String] {
        let themes =
            [["😈", "👻", "🎃", "🙀", "🤢", "😱", "👽", "☠️", "🍭", "👺"],
             ["😀", "🤪", "😭", "😰", "😓", "🤤", "😬", "😂", "🤨", "😔"],
             ["🐶", "🐹", "🐵", "🐸", "🐧", "🐞", "🐷", "🦜", "🐳", "🐔"],
             ["✈️", "🚘", "🚄", "🚀", "🛥", "🚡", "🏍", "🛴", "🚲", "🚊"],
             ["🌭", "🌮", "🍔", "🥗", "🍜", "🍕", "🍣", "🍧", "🥪", "🍗"],
             ["🍎", "🍐", "🍊", "🍋", "🍌", "🍇", "🍓", "🍍", "🍑", "🥑"]]
        let themeIndex = Int(arc4random_uniform(UInt32(themes.count)))
        return themes[themeIndex]
    }
    
    func emoji(for card : Card) -> String {
        if emojiTheme == nil {
            emojiTheme = ViewController.getRandomTheme()
        }
        if emoji[card.identifier] == nil {
            let randomEmojiIndex = Int(arc4random_uniform(UInt32(emojiTheme!.count)))
            emoji[card.identifier] = emojiTheme!.remove(at: randomEmojiIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}


