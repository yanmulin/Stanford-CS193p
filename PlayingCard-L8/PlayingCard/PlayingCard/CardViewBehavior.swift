//
//  CardViewBehavior.swift
//  PlayingCard
//
//  Created by 颜木林 on 2019/5/6.
//  Copyright © 2019 awen. All rights reserved.
//

import UIKit

class CardViewBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        addChildBehavior(behavior)
        return behavior
    }()
    
    lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0.0
        addChildBehavior(behavior)
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            if let item = item as? UIView {
                let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
                switch (item.center.x, item.center.y) {
                case let (x, y) where x <= center.x && y <= center.y:
                    push.angle = (CGFloat.pi / 2.0).arc4random
                case let (x, y) where x > center.x && y <= center.y:
                    push.angle = CGFloat.pi / 2.0 + (CGFloat.pi / 2.0).arc4random
                case let (x, y) where x <= center.x && y > center.y:
                    push.angle = (-CGFloat.pi / 2.0).arc4random
                case let (x, y) where x > center.x && y > center.y:
                    push.angle = -CGFloat.pi / 2.0 - (CGFloat.pi / 2.0).arc4random
                default:
                    push.angle = (CGFloat.pi * 2.0).arc4random
                }
                push.angle = (2.0 * CGFloat.pi).arc4random
                push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
                push.action = { [weak self, unowned push] in
                    self?.removeChildBehavior(push)
                }
            }
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        dynamicItemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        dynamicItemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

}
