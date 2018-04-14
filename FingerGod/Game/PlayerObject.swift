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
    public var income : Int
    public var incomeTick : Float
    public var _mana : Float
    public var _unitList : UnitGroup
    public var _city : City?
    public var _selectedPower : String
    public let color : [GLfloat]
    
    private var tickCount : Float
        
    public init(_ newId:Int, _ color:[GLfloat], _ startSpace: Point2D) {
        _followers = 1
        _unitList = UnitGroup()
        _gold = STARTING_GOLD
        _mana = 500
        self.color = color
        tickCount = 0
        income = 1
        incomeTick = 2.0
        _selectedPower = "Off"
        
        super.init()
        
        _city = City(startSpace, self)
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "UpdatePlayerMana":
            _mana += params["ManaValue"]! as! Float
            break
            
        case "PowerOn":
            _selectedPower = params["power"]! as! String
            if (_selectedPower == "fire") {
                print("Fire Power");
            }
            
            if (_selectedPower == "water") {
                print("Water Power");
            }
            
            if (_selectedPower == "Off") {
                print("Power Off");
            }
            break
            
        default:
            break
        }
    }
    
    public override func update(delta: Float) {
        super.update(delta: delta)
        
        tickCount += delta
        if(tickCount >= incomeTick) {
            _gold += income
            tickCount -= incomeTick
        }
        
        var params = [String:Any]()
        params["Followers"] = String(_followers)
        params["Gold"] = String(_gold)
        params["Mana"] = String(_mana)
        EventDispatcher.publish("UpdatePlayerUI", params)
    }
}

