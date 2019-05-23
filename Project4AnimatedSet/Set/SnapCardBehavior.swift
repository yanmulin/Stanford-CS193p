//
//  SnapCardBehavior.swift
//  Set
//
//  Created by 颜木林 on 2019/5/7.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class SnapCardBehavior: UIDynamicBehavior {
    
    private(set) var items = [UIDynamicItem]()
    
    func snap(_ item: UIDynamicItem, to point: CGPoint) {
        let snap = UISnapBehavior(item: item, snapTo: point)
        addChildBehavior(snap)
        items.append(item)
    }
    
    func removeAllSnaps() {
        for behavior in childBehaviors {
            removeChildBehavior(behavior)
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

}
