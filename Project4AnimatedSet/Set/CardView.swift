//
//  CardView.swift
//  Set
//
//  Created by awen on 2019/4/30.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var isFaceUp: Bool = true { didSet{setNeedsDisplay()} }
    var shape: Card.Shape = .diamond { didSet{setNeedsDisplay()} }
    var shading: Card.Shading = .outlined { didSet{setNeedsDisplay()} }
    @IBInspectable var color: UIColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) { didSet{setNeedsDisplay()} }
    @IBInspectable var shapeCount: Int = 1 { didSet{setNeedsDisplay()} }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        DisplayConst.cardFrontColor.setFill()
        roundedRect.addClip()
        roundedRect.fill()
        
        if isFaceUp {
            if (shapeCount > 0) {
                var rect = CGRect(x: horizontalMargin, y: verticalMargin, width: drawingWidth, height: drawingHeight)
                
                for _ in 0..<shapeCount {
                    drawPattern(in: rect)
                    rect.origin.y += drawingHeight + drawingSpacing
                }
            }
        } else {
            let rect = UIBezierPath(rect: bounds)
            DisplayConst.cardBackColor.setFill()
            rect.fill()
        }
    }
    
    private func drawPattern(in rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            var path: UIBezierPath
            switch shape {
                case .squiggle: path = drawSquiggle(in: rect)
                case .oval: path = drawOval(in: rect)
                case .diamond: path = drawDiamond(in: rect)
            }
            path.lineWidth = outlineWidth
            color.setStroke()
            path.stroke()
            path.addClip()
            
            switch shading {
            case .filled: drawFill(in: rect)
            case .stripped: drawStrips(in: rect)
            case .outlined:break
            }
            context.restoreGState()
        }
    }
    
    private func drawSquiggle(in rect: CGRect) -> UIBezierPath{
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let oneNinthWidth = rect.width / 9
        let halfOneNinthWidth = oneNinthWidth / 2
        let halfBoundsWidth = rect.width / 2
        let bigArcRadius = (halfBoundsWidth + halfOneNinthWidth) / 2
        let leftBigArcCenter = CGPoint(x: rect.minX + bigArcRadius, y: rect.midY)
        let rightBigArcCenter = CGPoint(x: rect.maxX - bigArcRadius, y: rect.midY)
        let smallArcRadius = 3 * halfOneNinthWidth
        let edgeArcRadius = halfOneNinthWidth
        let leftSmallArcCenter = CGPoint(x: rect.minX + smallArcRadius + 2 * edgeArcRadius, y: rect.midY)
        let rightSmallArcCenter = CGPoint(x: rect.maxX - smallArcRadius - 2 * edgeArcRadius, y: rect.midY)
        let offset = (smallArcRadius + edgeArcRadius) * cos(CGFloat.pi / 4)
        let rotateRadium = -CGFloat.pi / 5
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX + halfOneNinthWidth, y: rect.midY)
            .rotate(by: rotateRadium, with: center))
        path.addArc(
            withCenter: rightSmallArcCenter.rotate(by: rotateRadium, with: center),
            radius: smallArcRadius,
            startAngle: CGFloat.pi + rotateRadium,
            endAngle: CGFloat.pi / 3 + rotateRadium,
            clockwise: false
        )
        path.addArc(
            withCenter: rightSmallArcCenter.offset(dx: offset, dy: offset).rotate(by: rotateRadium, with: center),
            radius: edgeArcRadius,
            startAngle: -2 * CGFloat.pi / 3 + rotateRadium,
            endAngle: CGFloat.pi / 3 + rotateRadium,
            clockwise: true
        )
        path.addArc(
            withCenter: rightBigArcCenter.rotate(by: rotateRadium, with: center),
            radius: bigArcRadius,
            startAngle: CGFloat.pi / 3 + rotateRadium,
            endAngle: CGFloat.pi + rotateRadium,
            clockwise: true
        )
        path.addArc(
            withCenter: leftSmallArcCenter.rotate(by: rotateRadium, with: center),
            radius: smallArcRadius,
            startAngle: 0 + rotateRadium,
            endAngle: -2 * CGFloat.pi / 3 + rotateRadium,
            clockwise: false
        )
        path.addArc(
            withCenter: leftSmallArcCenter.offset(dx: -offset, dy: -offset).rotate(by: rotateRadium, with: center),
            radius: edgeArcRadius,
            startAngle: CGFloat.pi / 3 + rotateRadium,
            endAngle: -2 * CGFloat.pi / 3 + rotateRadium,
            clockwise: true
        )
        path.addArc(
            withCenter: leftBigArcCenter.rotate(by: rotateRadium, with: center),
            radius: bigArcRadius,
            startAngle: -2 * CGFloat.pi / 3 + rotateRadium,
            endAngle: 0 + rotateRadium,
            clockwise: true
        )
        return path
    }
    
    private func drawOval(in rect: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: rect.width / 2)
    }
    
    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.close()
        return path
    }
    
    private func drawFill(in rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        color.setFill()
        path.fill()
    }
    
    private func drawStrips(in rect: CGRect) {
        let path = UIBezierPath()
        let verticalSpacing = rect.height / CGFloat(DrawingConst.stripsCount / 2)
        let horizontalSpacing = rect.width / CGFloat(DrawingConst.stripsCount / 2)
        var y = rect.maxY
        for x in stride(from:rect.minX, to: rect.maxX, by: horizontalSpacing) {
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
            if (x != rect.minX) {
                path.move(to: CGPoint(x: rect.minX, y: y))
                path.addLine(to: CGPoint(x: x, y: rect.maxY))
            }
            y -= verticalSpacing
        }
        color.setStroke()
        path.lineWidth = min(horizontalSpacing, verticalSpacing) * 0.1
        path.stroke()
    }
}

extension CardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.05
        static let drawingHeightToBoundsHeight: CGFloat = 0.2
        static let horizontalMarginToBoundsWidth: CGFloat = 0.2
        static let drawingSpacingToLeftRoom: CGFloat = 0.2
    }
    
    public struct DisplayConst {
        static let cardBackColor: UIColor = .lightGray
        static let cardFrontColor: UIColor = .white
    }
    
    private struct DrawingConst {
        static let stripsCount: Int = 30
        static let StrokeLineWidthToBoundsSize: CGFloat = 0.008
    }
    
    private var cornerRadius: CGFloat {
        return bounds.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var verticalMargin: CGFloat {
        if (shapeCount <= 0) {
            return bounds.height / 2
        } else {
            return (bounds.height - (CGFloat(shapeCount) * drawingHeight) - CGFloat(shapeCount - 1) * drawingSpacing) / 2
        }
    }
    
    private var horizontalMargin: CGFloat {
        return bounds.width * SizeRatio.horizontalMarginToBoundsWidth / 2
    }
    
    private var drawingSpacing: CGFloat {
        if shapeCount <= 1 {
            return 0
        } else {
            return ((bounds.height - (CGFloat(shapeCount) * drawingHeight)) * SizeRatio.drawingSpacingToLeftRoom) / CGFloat(shapeCount - 1)
        }
    }
    
    private var drawingHeight: CGFloat {
        return bounds.height * SizeRatio.drawingHeightToBoundsHeight
    }
    
    private var drawingWidth: CGFloat {
        return bounds.width - 2 * horizontalMargin
    }
    
    private var outlineWidth: CGFloat {
        return min(bounds.height, bounds.width) * DrawingConst.StrokeLineWidthToBoundsSize
    }
}

extension CGPoint {
    func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
    
    func distance(to p: CGPoint) ->CGFloat {
        let dx = x - p.x
        let dy = y - p.y
        return CGFloat(sqrt(dx * dx + dy * dy))
    }
    
    func rotate(by radium: CGFloat, with r: CGPoint) -> CGPoint {
        let newX = (x - r.x)*cos(radium) - (y - r.y)*sin(radium) + r.x
        let newY = (x - r.x)*sin(radium) + (y - r.y)*cos(radium) + r.y
        return CGPoint(x: newX, y: newY)
    }
}

extension CGRect {
}
