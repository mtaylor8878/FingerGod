//
//  PlayerObject.swift
//  FingerGod
//
//  Created by Matt on 2018-03-22.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class PlayerObject : GameObject {
    public let STARTING_GOLD = 100
    
    public var _followers : Int
    public var _gold : Int
    public var _mana : Float
    public var _unitList : UnitGroup
    public var _city : City?

    
    public init(_ newId:Int, _ startSpace: Tile) {
        _followers = 1
        _unitList = UnitGroup()
        _gold = STARTING_GOLD
        _mana = 500
        super.init(id: newId)
        
        _city = City(startSpace, self)
    }
}

