//
//  CardBehavior.swift
//  Set
//
//  Created by 颜木林 on 2019/5/6.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    private lazy var collisionBehavior: UICollisionBehavior = {
       let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        addChildBehavior(behavior)
        return behavior
    }()
    
    private lazy var dynamicItemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.1
        behavior.resistance = 0.0
        addChildBehavior(behavior)
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.magnitude = CGFloat(10.0) + CGFloat(3.0).arc4random
        push.angle = (2 * CGFloat.pi).arc4random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
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
    
    var items: [UIDynamicItem] {
        return dynamicItemBehavior.items
    }
    
    override init() {
        super.init()
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

}


extension CGFloat {
    var arc4random: CGFloat {
        return (CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max)) * self
    }
}
