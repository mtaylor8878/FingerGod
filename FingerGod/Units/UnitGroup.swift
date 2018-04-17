//
//  UnitGroup.swift
//  FingerGod
//
//  Created by Jade Zhang on 2018-03-03.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class UnitGroup: NSObject {
    var peopleArray = NSMutableArray()
    
    //Initialize unitGroup
    init(peopleNum: NSInteger) {
        super.init()
        for _ in 0..<peopleNum {
            let singleUnit = SingleUnit.init()
            singleUnit.character = Character.PEOPLE
            peopleArray.add(singleUnit)
        }
    }
    
    //After the attack is completed, the population will be reduced according to the HP value. Returns the number of people that are remaining
    func removeDeadUnits() -> NSInteger {
        for u in peopleArray.reversed() {
            let singleUnit = u as! SingleUnit
            if singleUnit.dead {
                self.peopleArray.removeObject(identicalTo: singleUnit)
            }
        }
        return peopleArray.count
    }
    
    
}

