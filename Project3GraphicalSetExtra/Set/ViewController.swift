//
//  ViewController.swift
//  Set
//
//  Created by 颜木林 on 2019/4/22.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SetViewDelegate, SetViewDataSource {
    
    @IBOutlet private weak var scoreLab: UILabel!
    @IBOutlet private weak var setView: SetView! {
        didSet {
            setView.delegate = self
            setView.dataSource = self
        }
    }
    
    private var game = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScore()
        
        // Extra
        user1TimeLab.isHidden = true
        user2TimeLab.isHidden = true
    }
    
    private func updateScore() {
//        scoreLab.text = "Score: \(game.score)"
        scoreLab.text = "Score\n\(user1Score)/\(user2Score)"
    }
    @IBAction private func clickNewGame(_ sender: UIButton) {
        game = Set()
        setView.reloadCards()
        updateScore()
    }
    @IBAction private func deal3MoreCards(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            if game.deckCards.count > 0 {
                game.deal3MoreCards()
                setView.reloadCards()
            }
        default: break
        }
        
        stopWaiting()
    }
    
    @IBAction private func reshuffle(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.reshufflePlayingCards()
            setView.reloadCards()
        default: break
        }
    }
    @IBAction private func clickHelp(_ sender: Any) {
        if game.selectedCardIndices.count == 3 {
            game.choose(at: game.selectedCardIndices[0])
            setView.reloadCards()
        } else if game.selectedCardIndices.count > 0 {
             return
        }
        for i in 0..<game.playedCards.count - 2 {
            if game.playedCards[i].isMatched {
                continue
            }
            for j in i+1..<game.playedCards.count-1 {
                if game.playedCards[j].isMatched {
                    continue
                }
                for k in j+1..<game.playedCards.count {
                    if game.playedCards[i].isMatched {
                        continue
                    }
                    let card1 = game.playedCards[i]
                    let card2 = game.playedCards[j]
                    let card3 = game.playedCards[k]
                    if card1.match(card2, card3) {
                        game.choose(at: i)
                        game.choose(at: j)
                        game.choose(at: k)
                        updateScore()
                        setView.reloadCards()
                        return
                    }
                }
             }
        }
    }
    
    // MARK: SetViewDelegate, SetViewDataSource
    func numberOfCards() -> Int {
        return game.playedCards.count
    }
    
    func viewForCard(at index: Int) -> UIView {
        if !game.playedCards[index].isMatched {
            let view = CardView()
            view.backgroundColor = UIColor.clear
            view.isOpaque = false
            view.clipsToBounds = true
            view.shape = game.playedCards[index].shape
            view.shading = game.playedCards[index].shading
            view.shapeCount = game.playedCards[index].number
            view.color = game.playedCards[index].color.rawValue
            return view
        } else {
            return UIView()
        }
    }
    
    func selectedCardIndices() -> [Int] {
        return game.selectedCardIndices
    }
    
    func isSelectedCardsMatched() -> Bool {
        return game.isThreeCardsSelectedAndMatched
    }
    
    // Extra
    func allowToSelect(_ index: Int) -> Bool {
        return isUser1FindingSet || isUser2FindingSet
    }
    
    func didSelectCard(at index: Int) {
        game.choose(at: index)
        updateScore()
        setView.reloadCards()
        
        if isAnyUserFindingSet && game.selectedCardIndices.count == 3 {
            stopWaiting()
        }
    }
    
    // MARK: Extra Credit
    var user1Score = 0
    var user2Score = 0
    @IBOutlet weak var user1Btn: UIButton!
    @IBOutlet weak var user1TimeLab: UILabel!
    @IBOutlet weak var user2Btn: UIButton!
    @IBOutlet weak var user2TimeLab: UILabel!
    var timer = Timer()
    var secondsToWait = 0
    var secondsToWaitForNextTime = 5
    var isUser1FindingSet: Bool = false
    var isUser2FindingSet: Bool = false
    var isAnyUserFindingSet: Bool {
        return isUser1FindingSet || isUser2FindingSet
    }
    var nextNoPenalty = false
    
    func waitSeconds(_ seconds: Int) {
        secondsToWait = seconds
        setView.reloadCards()
        updateSeconds()
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { _ in self.manageTime() }
        )
        
    }
    
    @objc func manageTime() {
        secondsToWait -= 1
        updateSeconds()
        if secondsToWait <= 0 {
            stopWaiting()
        }
    }
    
    func stopWaiting() {
        timer.invalidate()
        if game.isThreeCardsSelectedAndMatched {
            updateScore(with: 5)
            secondsToWaitForNextTime = 5
            user1TimeLab.isHidden = true
            user2TimeLab.isHidden = true
            isUser1FindingSet = false
            isUser2FindingSet = false
            game.choose(at: game.selectedCardIndices[0])
            setView.reloadCards()
        } else if secondsToWait != 0 && game.selectedCardIndices.count != 3 { // Deal3MoreCards
            updateScore(with: -1)
            secondsToWaitForNextTime = 5
            nextNoPenalty = true
            isUser1FindingSet = !isUser1FindingSet
            isUser2FindingSet = !isUser2FindingSet
            user1TimeLab.isHidden = !user1TimeLab.isHidden
            user2TimeLab.isHidden = !user2TimeLab.isHidden
            waitSeconds(secondsToWaitForNextTime)
        } else { // not matched or overtime
            updateScore(with: -3)
            if game.selectedCardIndices.count == 3 {
                game.choose(at: game.selectedCardIndices[0])
            }
            secondsToWaitForNextTime = secondsToWaitForNextTime * 2
            isUser1FindingSet = !isUser1FindingSet
            isUser2FindingSet = !isUser2FindingSet
            user1TimeLab.isHidden = !user1TimeLab.isHidden
            user2TimeLab.isHidden = !user2TimeLab.isHidden
            waitSeconds(secondsToWaitForNextTime)
        }
    }
    
    func updateScore(with increment: Int) {
        if !nextNoPenalty || increment > 0 {
            nextNoPenalty = false
            if isUser1FindingSet && !isUser2FindingSet {
                user1Score += increment
            } else if !isUser1FindingSet && isUser2FindingSet {
                user2Score += increment
            } else {
                assert(false)
            }
        }
        updateScore()
    }
    
    @IBAction func user1Find(_ sender: UIButton) {
        isUser1FindingSet = true
        isUser2FindingSet = false
        user1TimeLab.isHidden = false
        user2TimeLab.isHidden = true
        waitSeconds(secondsToWaitForNextTime)
    }
    
    @IBAction func user2Find(_ sender: UIButton) {
        isUser1FindingSet = false
        isUser2FindingSet = true
        user1TimeLab.isHidden = true
        user2TimeLab.isHidden = false
        waitSeconds(secondsToWaitForNextTime)
    }

    func updateSeconds() {
        if isUser1FindingSet && !isUser2FindingSet {
            user1TimeLab.text = "\(secondsToWait)"
        } else if isUser2FindingSet && !isUser1FindingSet {
            user2TimeLab.text = "\(secondsToWait)"
        } else {
            assert(false)
        }
    }
    
}

