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
    var followerArray = NSMutableArray()
    var demiGodArray = NSMutableArray()
    
    //Initialize unitGroup
    static func initUnitGroupWith(peopleNum: NSInteger, followerNum :NSInteger, demiGodNum :NSInteger) -> UnitGroup {
        let unitGroup = UnitGroup.init()
        for _ in 0..<peopleNum {
            let singleUnit = SingleUnit.init()
            singleUnit.character = Character.PEOPLE
            unitGroup.peopleArray.add(singleUnit)
        }
        for _ in 0..<followerNum {
            let singleUnit = SingleUnit.init()
            singleUnit.character = Character.FOLLOWER
            unitGroup.followerArray.add(singleUnit)
        }
        for _ in 0..<demiGodNum {
            let singleUnit = SingleUnit.init()
            singleUnit.character = Character.DEMIGOD
            unitGroup.demiGodArray.add(singleUnit)
        }
        return unitGroup
    }
    
    //After the attack is completed, the population will be reduced according to the HP value. If demygod's hp is zero, the number of dead will be returned to increase the number of enemy demigod.
    func removeUnitNum() -> NSInteger{
        var num:NSInteger = self.peopleArray.count
        for u in peopleArray.reversed() {
            var singleUnit = u as! SingleUnit
            if singleUnit.HP <= 0 {
                self.peopleArray.removeObject(identicalTo: singleUnit)
            }
        }
        num = self.followerArray.count
        for u in followerArray.reversed() {
            var singleUnit = u as! SingleUnit
            if singleUnit.HP <= 0 {
                self.followerArray.removeObject(identicalTo: singleUnit)
            }
        }
        num = self.demiGodArray.count
        var deathDemyGodNum = 0
        for u in followerArray.reversed() {
            var singleUnit = u as! SingleUnit
            if singleUnit.HP <= 0 {
                self.demiGodArray.removeObject(identicalTo: singleUnit)
                deathDemyGodNum = deathDemyGodNum + 1
            }
        }
        return deathDemyGodNum
    }
    
    
}

