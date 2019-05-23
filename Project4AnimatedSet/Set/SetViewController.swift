//
//  ViewController.swift
//  Set
//
//  Created by 颜木林 on 2019/4/22.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, SetViewDelegate, SetViewDataSource {
    
    @IBOutlet weak var deckButton: UIButton!
    
    @IBOutlet weak var discardBtn: UIButton!
    
    @IBOutlet private weak var setView: SetView! {
        didSet {
            setView.delegate = self
            setView.dataSource = self
        }
    }
    
    @IBOutlet private weak var deckBackgroundCardView: CardView!
    @IBOutlet private weak var discardBackgroundCardView: CardView!
    
    private var setCount = 0 {
        didSet {
            discardBtn.setTitle("Set (\(setCount))", for: .normal)
        }
    }
    
    private var game = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(help(_:)))
        swipe.direction = [.left, .right]
        swipe.numberOfTouchesRequired = 1
        view.addGestureRecognizer(swipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (setView.subviews.count == 0) {
            setView.loadNewCards(Array<Int>(game.playedCards.indices), from: deckCardFrameInSetView)
        }
        if game.findASetOnPlayingCards() == nil {
            deckButton.sendActions(for: .touchUpInside)
        }
    }

    // MARK: Update
    private func updateDeckView() {
        if game.deckCards.count == 0 {
            deckBackgroundCardView.isHidden = true
        }
    }
    private func updateDiscardView() {
        if game.discardedCards.count > 0 {
            discardBackgroundCardView.isHidden = false
        }
    }
    
    @IBAction private func clickNewGame(_ sender: UIButton) {
        game = Set()
        setCount = 0
    }
    
    private var deckCardFrameInSetView: CGRect {
        let origin = deckBackgroundCardView.frame.origin.offset(dx: -setView.frame.origin.x, dy: -setView.frame.origin.y)
        let size = CGSize(width: deckBackgroundCardView.frame.width, height: deckBackgroundCardView.frame.height)
        return CGRect(origin: origin, size: size)
    }
    
    private var discardCardFrameInSetView: CGRect {
        let origin = discardBackgroundCardView.frame.origin.offset(dx: -setView.frame.origin.x, dy: -setView.frame.origin.y)
        let size = CGSize(width: discardBackgroundCardView.frame.width, height: discardBackgroundCardView.frame.height)
        return CGRect(origin: origin, size: size)
    }
    
    // MARK: Actions
    @IBAction func deal3MoreCards(sender: Any) {
        if game.deckCards.count > 0 {
            let newCardIndices = game.deal3MoreCards()
            setView.loadNewCards(newCardIndices, from: deckCardFrameInSetView)
            updateDeckView()
            if game.findASetOnPlayingCards() == nil {
                deckButton.sendActions(for: .touchUpInside)
            }
        }
    }
    
    @objc func help(_ gr: UISwipeGestureRecognizer) {
        switch gr.state {
        case .ended:
            if let (card1, card2, card3) = game.findASetOnPlayingCards() {
                setView.matchCards(for: [card1, card2, card3], true)
            }
        default: break
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
            view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            view.isFaceUp = true
            view.shape = game.playedCards[index].shape
            view.shading = game.playedCards[index].shading
            view.shapeCount = game.playedCards[index].number
            view.color = game.playedCards[index].color.rawValue
            return view
        } else {
            let view = UIView()
            view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            view.backgroundColor = UIColor.clear
            return view
        }
    }
    
    func selectedCardIndices() -> [Int] {
        return game.selectedCardIndices
    }
    
    func isSelectedCardsMatched() -> Bool {
        return game.isThreeCardsSelectedAndMatched
    }
    
    func didSelectCard(at index: Int) {
        game.choose(at: index)
        if game.selectedCardIndices.count == 3 {
            if game.isThreeCardsSelectedAndMatched {
                setCount += 1
                setView.flyCards(for: game.selectedCardIndices, to: discardCardFrameInSetView, completion: {
                    self.updateDiscardView()
                })
                let newCardsIndices = game.deal3MoreCards()
                if newCardsIndices.count > 0 {
                    setView.loadNewCards(newCardsIndices, from: deckCardFrameInSetView)
                } else {
                    setView.loadNewCards(game.selectedCardIndices, from: deckCardFrameInSetView)
                }
                if game.findASetOnPlayingCards() == nil {
                    deckButton.sendActions(for: .touchUpInside)
                }
                updateDeckView()
            } else {
                setView.matchCards(for: game.selectedCardIndices, false)
            }
        } else {
            setView.selectCard(for: game.selectedCardIndices)
        }
    }
    
    func allowToSelect(_ index: Int) -> Bool {
        return !game.playedCards[index].isMatched
    }
    
    func setViewDidFly() {
        updateDiscardView()
    }
    
    func discardPilesRect() -> CGRect {
        return discardCardFrameInSetView
    }
}

