//
//  EmojiArtView+Gestures.swift
//  EmojiArt-L11
//
//  Created by 颜木林 on 2019/5/18.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

extension EmojiArtView {
    func addGestureRecognizer(to view: UIView) {
//        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectSubview(by:))))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(selectAndMoveSubview(by:))))
    }
    
    
    var selectedSubview: UIView? {
        get {
            return subviews.filter { return $0.layer.borderWidth > 0.0 }.first
        }
        set {
            subviews.forEach { $0.layer.borderWidth = 0.0 }
            newValue?.layer.borderWidth = 1.0
            if newValue != nil {
                enableGestureRecognizer()
            } else {
                disableGestureRecognizer()
            }
        }
    }
    
    func enableGestureRecognizer() {
        if let scrollView = superview as? UIScrollView {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
        if gestureRecognizers == nil || gestureRecognizers!.count == 0 {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deselectSubview(by:))))
            addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoomSelectedSubview(by:))))
        } else {
            gestureRecognizers?.forEach { $0.isEnabled = true }
        }
    }
    
    func disableGestureRecognizer() {
        if let scrollView = superview as? UIScrollView {
            scrollView.panGestureRecognizer.isEnabled = true
            scrollView.pinchGestureRecognizer?.isEnabled = true
        }
        gestureRecognizers?.forEach { $0.isEnabled = false }
    }
    
    @objc func selectSubview(by tap: UITapGestureRecognizer) {
        selectedSubview = tap.view
    }
    
    @objc func selectAndMoveSubview(by pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            if selectedSubview != nil, pan.view != nil {
                selectedSubview = pan.view
            }
        case .changed, .ended:
            if selectedSubview != nil, pan.view != nil {
                pan.view?.center = pan.view!.center.offset(by: pan.translation(in: self))
                pan.setTranslation(CGPoint.zero, in: self)
            }
        default: break
        }
    }
    
    @objc func deselectSubview(by tap: UITapGestureRecognizer) {
        selectedSubview = nil
    }
    
    @objc func zoomSelectedSubview(by pinch: UIPinchGestureRecognizer) {
        switch pinch.state {
        case .changed, .ended:
            if let label = selectedSubview as? UILabel {
                label.attributedText = label.attributedText?.withFontScaled(by: pinch.scale)
                label.stretchToFit()
                pinch.scale = 1.0
            }
        default: break
        }
    }
    
}
