//
//  FirePower.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-04-13.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class FirePower : Power {
    
    var target : UnitGroupComponent?
    
    public override func update(delta: Float) {
        super.update(delta: delta)
    
        for u in (target?.unitGroup.peopleArray)! {
            let unit = u as! SingleUnit
            unit.hurt(damage:50)
        }
    }
}
