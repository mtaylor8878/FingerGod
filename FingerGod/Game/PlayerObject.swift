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
    public var _unitList : [UnitGroupComponent]
    
    public var _followers : Int
    public var _gold : Int
    public var income : Int
    public var incomeTick : Float
    public var _mana : Float
    public var _city : City?
    public var _curPower : Power?
    public let color : [GLfloat]
    public var powers : [Power]
    
    private var tickCount : Float
        
    public init(_ color:[GLfloat], _ startSpace: Point2D) {
        _followers = 100
        _gold = STARTING_GOLD
        _mana = 500
        self.color = color
        tickCount = 0
        income = 1
        incomeTick = 2.0
        
        _unitList = []
        powers = [Power]()
        super.init()
        powers.append(FirePower(player: self))
        powers.append(WaterPower(player: self))
        powers.append(EarthPower(player: self))
        
        EventDispatcher.subscribe("RemoveUnit", self)
        
        _city = City(startSpace, self)
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "RemoveUnit":
            let unit = params["unit"] as! UnitGroupComponent
            if (unit.alignment == Alignment.ALLIED) {
                let ind = _unitList.index{$0 === unit};
                if (ind != nil) {
                    _unitList.remove(at: ind!)
                }
            }
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

