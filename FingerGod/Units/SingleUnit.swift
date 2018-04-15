//
//  SingleUnit.swift
//  FingerGod
//
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import UIKit

//unit three style，people,follower,demigod
enum Character {
    case PEOPLE
    case FOLLOWER
    case DEMIGOD
}

class SingleUnit: NSObject {
    
    var HP = 100 //hp
    var character: Character?
    
    public func attack(targetGroup: UnitGroup) {
        // Default attack behaviour
        // 10% chance to attack, 90% chance to do nothing
        if (arc4random_uniform(10) >= 1) {
            return
        }
        let targets = targetGroup.peopleArray
        
        // If there are no people in the enemy army left, don't attack
        if (targets.count == 0) {
            return
        }
        let target = targets[Int(arc4random_uniform(UInt32(targets.count)))] as! SingleUnit
        
        target.hurt(damage: 10)
    }
    
    public func hurt(damage: Int) {
        // Default hurt behaviour
        HP = HP - damage
    }
    
    public func heal(damage: Int) {
        HP = HP + damage
    }
}

