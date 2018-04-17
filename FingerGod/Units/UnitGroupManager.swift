//
//  UnitGroupManagerComponent.swift
//  FingerGod
//
//  Created by Aaron F on 2018-04-15.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class UnitGroupManager : NSObject, Subscriber {
    public var unitGroups : [UnitGroupComponent] = []
    public var map : MapComponent
    public var game : Game
    
    public init(_ newGame : Game, _ newMap: MapComponent) {
        map = newMap
        game = newGame
        super.init()
        EventDispatcher.subscribe("AddUnit", self)
        EventDispatcher.subscribe("RemoveUnit", self)
        EventDispatcher.subscribe("UnitMoved", self)
        EventDispatcher.subscribe("BattleEnd", self)
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "AddUnit":
            let unit = params["unit"] as! UnitGroupComponent
            unitGroups.append(unit)
            break
        case "UnitMoved":
            let unit = params["unit"] as! UnitGroupComponent
            let newPos = params["newPos"] as! Point2D
            let oldPos = params["oldPos"] as? Point2D
            let unitsAtNewPos = unitsAtLocation(newPos)
            
            if (unitsAtNewPos.count > 0) {
                for otherUnit in unitsAtNewPos {
                    switch (otherUnit.alignment) {
                    case Alignment.ALLIED:
                        if (unit !== otherUnit && unit.alignment == otherUnit.alignment) {
                            // TODO: Ally Merge code
                        }
                        break
                    case Alignment.ENEMY:
                        if (unit.alignment != otherUnit.alignment) {
                            print("BATTLE START")
                            startBattle(unit, otherUnit)
                        }
                        break
                    case Alignment.NEUTRAL:
                        // Potentially follower capture code?
                        break
                    default:
                        break
                    }
                }
            }
            if (oldPos != nil && unitsAtLocation(oldPos!).count == 0) {
                EventDispatcher.publish("ResetTileType", ("pos", oldPos!))
            }
            EventDispatcher.publish("SetTileType", ("pos", newPos), ("type", Tile.types.occupied))
            
            break
        case "RemoveUnit":
            let unit = params["unit"] as! UnitGroupComponent
            game.removeGameObject(gameObject: unit.gameObject)
            let ind = unitGroups.index{$0 === unit};
            if (ind != nil) {
                unitGroups.remove(at: ind!)
                EventDispatcher.publish("ResetTileType", ("pos", Point2D(unit.position[0], unit.position[1])))
            }
            break
        case "BattleEnd":
            print("BATTLE END")
            let result = params["result"] as! String
            var groupA = params["groupA"] as! UnitGroupComponent
            var groupB = params["groupB"] as! UnitGroupComponent
            switch(result) {
            case "awin":
                EventDispatcher.publish("RemoveUnit", ("unit", groupB))
                groupA.offset(1.25, 0, 0)
                break
            case "bwin":
                EventDispatcher.publish("RemoveUnit", ("unit", groupA))
                groupB.offset(-1.25, 0, 0)
                break
            case "tie":
                EventDispatcher.publish("RemoveUnit", ("unit", groupA))
                EventDispatcher.publish("RemoveUnit", ("unit", groupB))
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    private func startBattle(_ unitGroupA : UnitGroupComponent, _ unitGroupB : UnitGroupComponent) {
        unitGroupA.offset(-1.25, 0, 0)
        unitGroupB.offset(1.25, 0, 0)
        
        var battleObj = GameObject()
        
        battleObj.addComponent(type: BattleComponent.self)
        
        var battleComp = battleObj.getComponent(type: BattleComponent.self)
        battleComp?.groupA = unitGroupA
        battleComp?.groupB = unitGroupB
        
        game.addGameObject(gameObject: battleObj)
        battleComp?.start()
    }
    
    private func unitsAtLocation(_ pos: Point2D) -> [UnitGroupComponent] {
        var units : [UnitGroupComponent] = []
        for unit in unitGroups {
            if (Point2D(unit.position[0], unit.position[1]) == pos) {
                units.append(unit)
            }
        }
        return units
    }
}
