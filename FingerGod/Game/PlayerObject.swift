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
    private static let PLAYER_COLOURS: [[Float]] = [
        [0.0, 0.39, 0.898, 1.0], // BLUE
        [1.0, 0.2, 0.2, 1.0], // RED
        [0, 0.647, 0.16, 1.0], // GREEN
        [0.98, 0.914, 0.098, 1.0], // YELLOW
        [0.455, 0, 0.757, 1.0], // PURPLE
        [1.0, 0.565, 0, 1.0], // ORANGE
        [0, 0.95, 1.0, 1.0], // CYAN
        [0.4, 0.286, 0, 1.0] // BROWN
    ]
    
    private static var NumPlayers: Int = 0
    
    public let STARTING_GOLD = 100
    
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
    private var _unitList : [UnitGroupComponent]
        
    public init(_ startSpace: Point2D) {
        _followers = 100
        _gold = STARTING_GOLD
        _mana = 500
        
        self.color = PlayerObject.PLAYER_COLOURS[PlayerObject.NumPlayers]
        PlayerObject.NumPlayers += 1
        
        tickCount = 0
        income = 1
        incomeTick = 2.0
        
        _unitList = []
        powers = [Power]()
        super.init()
        
        EventDispatcher.subscribe("RemoveUnit", self)
        
        _city = City(startSpace, self)
    }
    
    public func setupPowers() {
        let fire = FirePower(player: self)
        game!.addGameObject(gameObject: fire)
        powers.append(fire)
        let water = WaterPower(player: self)
        game!.addGameObject(gameObject: water)
        powers.append(water)
        let earth = EarthPower(player: self)
        game!.addGameObject(gameObject: earth)
        powers.append(earth)
    }
    
    public func addUnit(unit: UnitGroupComponent) {
        _unitList.append(unit)
    }
    
    public func getUnitList() -> [UnitGroupComponent] {
        return _unitList
    }
    
    public func removeUnit(unit: UnitGroupComponent) {
        if (unit.owner == self.id!) {
            let ind = _unitList.index{$0 === unit};
            if (ind != nil) {
                _unitList.remove(at: ind!)
            }
        }
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "RemoveUnit":
            let unit = params["unit"] as! UnitGroupComponent
            removeUnit(unit: unit)
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
    }
}

