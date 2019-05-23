//
//  ViewController.swift
//  PlayingCard
//
//  Created by awen on 2019/4/29.
//  Copyright © 2019 awen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardViewBehavior: CardViewBehavior = CardViewBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 0..<((cardViews.count + 1) / 2) {
            if let card = deck.draw() {
                cards += [card, card]
            }
        }
        for cardView in cardViews {
            cardView.isFacedUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.suit = card.suit.rawValue
            cardView.rank = card.rank.order
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardViewBehavior.addItem(cardView)
        }
    }
    
    var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter { $0.isFacedUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1.0 }
    }
    
    var isFaceUpCardMatched: Bool {
        return faceUpCardViews.count == 2 && faceUpCardViews[0].suit == faceUpCardViews[1].suit && faceUpCardViews[0].rank == faceUpCardViews[1].rank
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2  {
                cardViewBehavior.removeItem(chosenCardView)
                lastChosenCardView = chosenCardView
                UIView.transition(
                    with: chosenCardView,
                duration: 0.5,
                 options: [.transitionFlipFromLeft],
              animations: {
                    chosenCardView.isFacedUp = !chosenCardView.isFacedUp
                },
              completion: { position in
                let cardsToAnimate = self.faceUpCardViews
                if self.isFaceUpCardMatched {
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.75,
                               delay: 0,
                             options: [],
                          animations: {
                            cardsToAnimate.forEach {
                                $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                            }
                    },
                        completion: { position in
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                        $0.alpha = 0
                                    }
                            },
                                completion: { position in
                                    cardsToAnimate.forEach {
                                        $0.isHidden = true
                                        $0.alpha = 1.0
                                        $0.transform = .identity;
                                    }
                            }
                    )
                    })
                } else if cardsToAnimate.count == 2 {
                    if chosenCardView == self.lastChosenCardView {
                        cardsToAnimate.forEach { cardView in
                            UIView.transition(
                                with: cardView,
                                duration: 0.5,
                                options: [.transitionFlipFromLeft],
                                animations: {
                                    cardView.isFacedUp = false
                                },
                                completion: { position in
                                    self.cardViewBehavior.addItem(cardView)
                            })
                        }
                    }
                } else {
                    if !chosenCardView.isFacedUp {
                        self.cardViewBehavior.addItem(chosenCardView)
                    }
                }
                })
            }
        default: break
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max)) * self
    }
}
