//
//  PlayerObject.swift
//  FingerGod
//
//  Created by Matt on 2018-03-22.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import UIKit

public class PlayerObject : GameObject, Subscriber{
    public let STARTING_GOLD = 100
    
    public var _followers : Int
    public var _gold : Int
    public var _mana : Float
    public var _unitList : UnitGroup
    public var _city : City?
        
    public init(_ newId:Int, _ startSpace: Point2D) {
        _followers = 1
        _unitList = UnitGroup()
        _gold = STARTING_GOLD
        _mana = 500
        super.init(id: newId)
        
        _city = City(startSpace, self)
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "UpdatePlayerMana":
            _mana += params["ManaValue"]! as! Float
            break
        default:
            break
        }
    }
    
    public override func update(delta: Float) {
        super.update(delta: delta)
        var params = [String:Any]()
        params["Followers"] = String(_followers)
        params["Gold"] = String(_gold)
        params["Mana"] = String(_mana)
        EventDispatcher.publish("UpdatePlayerUI", params)
    }
}

