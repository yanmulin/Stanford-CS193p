//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by awen on 2019/4/30.
//  Copyright © 2019 awen. All rights reserved.
//

import UIKit


@IBDesignable class PlayingCardView: UIView {
    
    @IBInspectable var rank: Int = 9 { didSet{setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable var suit: String = "♣️" { didSet{setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable var isFacedUp: Bool = false { didSet{setNeedsDisplay(); setNeedsLayout()}}
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet{setNeedsDisplay()}}
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy gr: UIPinchGestureRecognizer) {
        switch gr.state {
        case .changed, .ended:
            faceCardScale *= gr.scale
            gr.scale = 1.0
        default: break
        }
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // use as many lines as needed
        addSubview(label)
        return label
    }
    
    private func configCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFacedUp
    }
    
    private func drawPips() {
        let pipsPerRowForRank = [[0], [1], [1, 1], [1, 1, 1], [2, 2], [2, 1, 2], [2, 2, 2], [2, 1, 2, 2], [2, 2, 2, 2], [2, 2, 1, 2, 2], [2, 2, 2, 2, 2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipsCount = CGFloat(pipsPerRowForRank.reduce(0){ max($0, $1.count) })
            let maxHorizontalPipsCount = CGFloat(pipsPerRowForRank.reduce(0){ max($0, $1.max() ?? 0) })
            let verticalPipsSpacing = pipRect.height / maxVerticalPipsCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipsSpacing)
            let propableOkayFontSize = verticalPipsSpacing / (attemptedPipString.size().height / verticalPipsSpacing)
            let propablyOkayPipString = centeredAttributedString(suit, fontSize: propableOkayFontSize)
            if (propablyOkayPipString.size().width > pipRect.width / maxHorizontalPipsCount) {
                return centeredAttributedString(suit, fontSize: propableOkayFontSize / (propablyOkayPipString.size().width / (pipRect.width / maxHorizontalPipsCount)))
            } else {
                return propablyOkayPipString
            }
        }
        
        if (pipsPerRowForRank.indices.contains(rank)) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipsRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset)
                .insetBy(dx: cornerString.size().width, dy: cornerString.size().height)
            let pipString = createPipString(thatFits: pipsRect)
            let pipRowSpacing = pipsRect.height / CGFloat(pipsPerRow.count)
            pipsRect.size.height = pipString.size().height
            pipsRect.origin.y += (pipRowSpacing - pipString.size().height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1: pipString.draw(in: pipsRect)
                case 2:
                    pipString.draw(in: pipsRect.lefthalf())
                    pipString.draw(in: pipsRect.righthalf())
                default:break
                }
                pipsRect.origin.y += pipRowSpacing
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configCornerLabel(lowerRightCornerLabel)
        
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .rotated(by: CGFloat.pi)
        
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.width, dy: -lowerRightCornerLabel.frame.height)

    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        
        
        if (isFacedUp) {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                drawPips()
            }
        } else {
            if let backCardImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                backCardImage.draw(in: bounds)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight;
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight;
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerCornerRadius
    }
    
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    func zoom(by ratio: CGFloat) -> CGRect {
        let offsetX = origin.x + width * (1 - ratio) / 2
        let offsetY = origin.y + height * (1 - ratio) / 2
        return CGRect(x: origin.x + offsetX, y: origin.y + offsetY, width: width * ratio, height: height * ratio)
    }
    
    func lefthalf() -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: width / 2, height: height)
    }
    
    func righthalf() -> CGRect {
        return CGRect(x: origin.x + width / 2, y: origin.y, width: width / 2, height: height)
    }
}
