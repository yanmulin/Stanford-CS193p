//
//  SetView.swift
//  Set
//
//  Created by awen on 2019/4/30.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

protocol SetViewDelegate: NSObjectProtocol {
    func didSelectCard(at index: Int)
    func allowToSelect(_ index: Int) -> Bool
    func setViewDidFly()
    func discardPilesRect() -> CGRect
}

protocol SetViewDataSource: NSObjectProtocol {
    func numberOfCards() -> Int
    func viewForCard(at index: Int) -> UIView
    func selectedCardIndices() -> [Int]
    func isSelectedCardsMatched() -> Bool
}

class SetView: UIView, UIDynamicAnimatorDelegate {
    
    weak var delegate: SetViewDelegate?
    weak var dataSource: SetViewDataSource?
    
    private lazy var grid: Grid = Grid(layout: Grid.Layout.aspectRatio(SizeToRatio.cardWidthToHeightRatio))
    
    var cardWidth: CGFloat {
        return grid.cellSize.width - 2 * horizontalPadding
    }
    
    var cardHeight: CGFloat {
        return grid.cellSize.height - 2 * verticalPadding
    }

    
    func selectCard(for indices: [Int]) {
        subviews.indices.forEach {
            if indices.contains($0) {
                subviews[$0].layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else {
                subviews[$0].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
    }
    
    func matchCards(for indices: [Int], _ isMatched: Bool) {
        subviews.indices.forEach {
            if indices.contains($0) {
                subviews[$0].layer.borderColor = (isMatched ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) : #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)).cgColor
            } else {
                subviews[$0].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
    }
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        for item in snapBehavior.items {
            if let view = item as? CardView, let rect = delegate?.discardPilesRect() {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: AnimationConst.cardFlipDuration,
                    delay: 0.0,
                    options: [.layoutSubviews],
                    animations: {
                        view.bounds.size = CGSize(width: rect.height, height: rect.width)
                        view.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2)
                }, completion: { position in
                        UIView.transition(
                            with: view,
                            duration: AnimationConst.cardFlipDuration,
                            options: [.transitionFlipFromLeft],
                            animations: {
                                view.isFaceUp = false
                        }, completion: { _ in
                            view.removeFromSuperview()
                            if let delegate = self.delegate {
                                delegate.setViewDidFly()
                            }
                        })
                })
                }
        }
        snapBehavior.removeAllSnaps()
    }
    
    private lazy var cardBehavior = CardBehavior(in: animator)
    private lazy var snapBehavior = SnapCardBehavior(in: animator)
    
    private weak var timer: Timer?
    
    func flyCards(for indices: [Int], to rect: CGRect, completion: @escaping ()->Void) {
        subviews.forEach { $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) }
//        grid.cellCount -= indices.count
        for i in indices {
            cardBehavior.addItem(subviews[i])
            if  let gr =  subviews[i].gestureRecognizers?[0] {
                subviews[i].removeGestureRecognizer(gr)
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                for item in self.cardBehavior.items {
                    self.cardBehavior.removeItem(item)
                    if let view = item as? CardView {
                        self.snapBehavior.snap(view, to: CGPoint(x: rect.midX, y: rect.midY))

                        }
                    }
            }
        }
    }
    
    func loadNewCards(_ indices:[Int], from rect: CGRect) {
        indices.forEach {
            if let view = dataSource?.viewForCard(at: $0) {
                if let delegate = delegate, delegate.allowToSelect($0) {
                    addTapGestureRecognizer(to: view)
                }
                view.layer.borderWidth = SizeToRatio.cardBorderWidthToCardHeight * frame.height
                addSubview(view)
                exchangeSubview(at: subviews.count - 1 , withSubviewAt: $0)
            }
        }
        layoutCards()
        
        var delay = 0.0
        for index in indices {
            if let view = subviews[index] as? CardView, let gridFrame = grid[index] {
                let cardFrame = gridFrame.inset(by: UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding))
                view.frame = cardFrame
                view.center = CGPoint(x: rect.midX, y: rect.midY)
                view.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 2).scaledBy(x: rect.height / gridFrame.width, y: rect.width / gridFrame.height)
                view.isFaceUp = false
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: AnimationConst.cardDealingDuration,
                    delay: delay,
                    options: [],
                    animations: {
                        view.center = CGPoint(x: cardFrame.midX, y: cardFrame.midY)
                        view.transform = CGAffineTransform.identity
                }, completion: { position in
                    UIView.transition(
                        with: view,
                        duration: AnimationConst.cardFlipDuration,
                        options: [.transitionFlipFromLeft],
                        animations: {
                            view.isFaceUp = true
                    })
                })

                delay += AnimationConst.cardDealingDelayGap
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCards()
    }
    
    private func layoutCards() {
        grid.frame = bounds
        if let numberOfCards = dataSource?.numberOfCards() {
            grid.cellCount = numberOfCards
            for i in 0..<min(subviews.count, numberOfCards) {
                if let gridFrame = grid[i] {
                    subviews[i].frame = gridFrame.inset(by: UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding))
                }
            }
        }
    }

    private func addTapGestureRecognizer(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(with:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tap(with gr: UIGestureRecognizer) {
        if let view = gr.view, let index = subviews.firstIndex(of: view) {
            delegate?.didSelectCard(at: index)
        }
    }
}

extension SetView {
    private struct SizeToRatio {
        static let cardCornerRadiusToCardHeight: CGFloat = 0.08
        static let cardBorderWidthToCardHeight: CGFloat = 0.005
        static let horizontalPaddingToBoundsWidth: CGFloat = 0.008
        static let verticalPaddingToBoundsHeight: CGFloat = 0.010
        static let cardWidthToHeightRatio: CGFloat = 0.625
    }
    
    private struct AnimationConst {
        static let cardDealingDuration = 0.3
        static let cardDealingDelayGap = 0.2
        static let cardFlipDuration = 0.3
    }
    
    private var horizontalPadding: CGFloat {
        return bounds.width * SizeToRatio.horizontalPaddingToBoundsWidth
    }
    
    private var verticalPadding: CGFloat {
        return bounds.height * SizeToRatio.verticalPaddingToBoundsHeight
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
}

extension UIView {
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
