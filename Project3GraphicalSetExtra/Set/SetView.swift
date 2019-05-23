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
}

protocol SetViewDataSource: NSObjectProtocol {
    func numberOfCards() -> Int
    func viewForCard(at index: Int) -> UIView
    func selectedCardIndices() -> [Int]
    func isSelectedCardsMatched() -> Bool
}

class SetView: UIView {
    
    weak var delegate: SetViewDelegate?
    weak var dataSource: SetViewDataSource? { didSet { reloadCards() } }
    
    private lazy var grid: Grid = Grid(layout: Grid.Layout.aspectRatio(5.0/8.0), frame: bounds)
    
    func reloadCards() {
        removeAllSubviews()
        if let dataSource = dataSource {
            let numberOfCards = dataSource.numberOfCards()
            let selectedCardsIndices = dataSource.selectedCardIndices()
            var selectedBorderColor: UIColor
            if selectedCardsIndices.count == 3 {
                if dataSource.isSelectedCardsMatched() {
                    selectedBorderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                } else {
                    selectedBorderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                }
            } else {
                selectedBorderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            }
            grid.cellCount = numberOfCards
            for i in 0..<numberOfCards {
                let view = dataSource.viewForCard(at: i)
                view.layer.borderColor = selectedCardsIndices.contains(i) ? selectedBorderColor.cgColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                if let delegate = delegate, delegate.allowToSelect(i) {
                    addTapGestureRecognizer(to: view)
                }
                addSubview(view)
            }
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        for i in subviews.indices {
            if let frame = grid[i] {
                subviews[i].frame = frame.inset(by: UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding))
                subviews[i].layer.borderWidth = SizeToRatio.cardBorderWidthToCardHeight * frame.height
//                subviews[i].layer.cornerRadius = SizeToRatio.cardCornerRadiusToCardHeight * frame.height
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
        static let cardCornerRadiusToCardHeight: CGFloat = 0.05
        static let cardBorderWidthToCardHeight: CGFloat = 0.025
        static let horizontalPaddingToBoundsWidth: CGFloat = 0.005
        static let verticalPaddingToBoundsHeight: CGFloat = 0.005
    }
    
    private var horizontalPadding: CGFloat {
        return bounds.width * SizeToRatio.horizontalPaddingToBoundsWidth
    }
    
    private var verticalPadding: CGFloat {
        return bounds.height * SizeToRatio.verticalPaddingToBoundsHeight
    }
}

extension UIView {
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
