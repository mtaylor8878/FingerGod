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
    
    private var _followers : Int
    private var _gold : Int
    private var _mana : Float
    private var _unitList : UnitGroup
    private var _city : City?
    
    public init(_ newId:Int, _ startSpace: Tile) {
        _followers = 1
        _unitList = UnitGroup()
        _gold = STARTING_GOLD
        _mana = 0
        
        super.init(id: newId)
        
        _city = City(startSpace, self)
    }
}

