//
//  UnitArrayModel.swift
//  FingerGod
//
//  Created by Jade Zhang on 2018-02-23.
//  Copyright © 2018年 Ramen Interactive. All rights reserved.
//

import Foundation

public class UnitArrayModel: NSObject {
    var unitArray:NSMutableArray?

    //initialize the unit model
    func initUnitArray() {
        unitArray = NSMutableArray.init()
        let unitModel = UnitModel.init()
        unitModel.unitID = "name"
        self.unitArray?.add(unitModel)
    }

    //add unit into unit model
    func addUnit(unitID :String) {
        let unitModel = UnitModel.init()
        unitModel.unitID = unitID
        self.unitArray?.add(unitModel)
    }

    //delete unit from unit model
    func removeUnitWithName(unitID :String) {
        let num:NSInteger = (unitArray?.count)!
        for m in 0...num - 1  {
            let unitData:UnitModel = unitArray![m] as! UnitModel
            if unitData.unitID == unitID {
                unitArray?.removeObject(at: m)
            }
        }
    }




}
