//
//  MapComponent.swift
//  FingerGod
//
//  Created by Aaron F on 2018-02-28.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import UIKit
import GLKit

public class MapComponent : Component, Subscriber {
    
    private var tileMap : TileMap!
    private var selected: Point2D?
    
    // TEMPORARY VALUES
    private var unitGroupIDs = 10000
    private var battleIDs = 100000
    private var unitGroupComps = [UnitGroupComponent]()
    
    open override func create() {
        tileMap = TileMap(10,1)
        
        EventDispatcher.subscribe("ClickMap",self)
        EventDispatcher.subscribe("DispatchUnitGroup",self)
        EventDispatcher.subscribe("moveGroupUnit",self)
        EventDispatcher.subscribe("AddStructure", self)
        EventDispatcher.subscribe("BattleEnd",self)
        
        let testEnemy = GameObject()
        testEnemy.addComponent(type: UnitGroupComponent.self)
        
        self.gameObject.game!.addGameObject(gameObject: testEnemy)
        let ugComp = testEnemy.getComponent(type: UnitGroupComponent.self)
        ugComp?.move(3, 3)
        ugComp?.setAlignment(Alignment.ENEMY)
        unitGroupComps.append(ugComp!)
    }
    
    public func getClosest(_ coord: GLKVector3) -> Point2D {
        var shortest = Float(255)
        var select: Point2D!
        
        for (point, tile ) in tileMap.getTiles() {
            let tileCoord = GLKVector3Make(tile.worldCoordinate.0, 0, tile.worldCoordinate.1)
            let dist = GLKVector3Distance(tileCoord, coord)
            if dist < shortest {
                shortest = dist
                select = point
            }
        }
        
        return select
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "moveGroupUnit":
            let str: String! = params["direction"] as! String
            if str == "left" {
                selectTile((selected?.x)! - 1, (selected?.y)!)
            }
            if str == "right" {
                selectTile((selected?.x)! + 1, (selected?.y)!)
            }
            break
            
        case "AddStructure":
            let str = params["structure"]! as! Structure
            let pos = params["coords"]! as! Point2D
            tileMap.getTile(pos)?.addStructure(str)
            break
            
        case "ClickMap":
            let point = params["coord"] as! GLKVector3
            let closestTile = getClosest(point)
            let tile = tileMap.getTile(closestTile)!
            var outputString = "\nPoint: (" + String(point.x) + "," + String(point.y) + "," + String(point.z) + ")"
            outputString += "\nTile Axial: (" + String(closestTile.x) + "," + String(closestTile.y) + ")"
            outputString += "\nTile World: (" + String(tile.worldCoordinate.x) + "," + String(tile.worldCoordinate.y) + ")"
            NSLog(outputString)
            let number = params["power"] as! Int
            if (number > 0) {
                powerTile(closestTile.x, closestTile.y, number)
            } else {
                selectTile(closestTile.x, closestTile.y)
            }
            break
            
        case "DispatchUnitGroup":
            let unitGroup = GameObject()
            unitGroupIDs = unitGroupIDs + 1
            unitGroup.addComponent(type: UnitGroupComponent.self)
            self.gameObject.game?.addGameObject(gameObject: unitGroup)
            
            var unitGroupComponent = unitGroup.getComponent(type: UnitGroupComponent.self)!
            unitGroupComponent.move(5, 0)
            unitGroupComponent.setAlignment(Alignment.ALLIED)
            
            unitGroupComps.append(unitGroupComponent)
            break
            
        case "BattleEnd":
            print("BATTLE END")
            let result = params["result"] as! String
            var groupA = params["groupA"] as! UnitGroupComponent
            var groupB = params["groupB"] as! UnitGroupComponent
            switch(result) {
            case "awin":
                self.gameObject.game?.removeGameObject(gameObject: groupB.gameObject)
                self.unitGroupComps.remove(at: self.unitGroupComps.index{$0 === groupB}!)
                groupA.offset(1.25, 0, 0)
                break
            case "bwin":
                self.gameObject.game?.removeGameObject(gameObject: groupA.gameObject)
                self.unitGroupComps.remove(at: self.unitGroupComps.index{$0 === groupA}!)
                groupB.offset(-1.25, 0, 0)
                break
            case "tie":
                self.gameObject.game?.removeGameObject(gameObject: groupA.gameObject)
                self.gameObject.game?.removeGameObject(gameObject: groupB.gameObject)
                self.unitGroupComps.remove(at: self.unitGroupComps.index{$0 === groupA}!)
                self.unitGroupComps.remove(at: self.unitGroupComps.index{$0 === groupB}!)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    public func selectTile(_ q: Int, _ r: Int) {
        var nextObject : UnitGroupComponent? = nil
        var prevObject : UnitGroupComponent? = nil
        if(selected != nil) {
            tileMap.getTile(selected!)?.resetColor()
            for c in unitGroupComps {
                if c.position[0] == selected?.x && c.position[1] == selected?.y {
                    // There was a unit on our selected tile, move it to the new tile
                    prevObject = c
                }
                if c.position[0] == q && c.position[1] == r {
                    nextObject = c
                }
            }
        }
        
        if (prevObject != nil && prevObject!.alignment == Alignment.ALLIED) {
            if (nextObject == nil) {
                // There was a unit on our selected tile, move it to the new tile
                prevObject!.move(q, r)
                selected = nil
                return
            }
            else if (nextObject != nil && nextObject!.alignment == Alignment.ENEMY){
                // INITIATE BATTLE
                print("BATTLE START")
                startBattle(prevObject!, nextObject!)
                selected = nil
                return
            }
        }
        selected = Point2D(q,r)
        tileMap.getTile(selected!)!.model.color = [1.0, 0.2, 0.2, 1.0]
    }
    
    private func startBattle(_ unitGroupA : UnitGroupComponent, _ unitGroupB : UnitGroupComponent) {
        unitGroupA.move(unitGroupB.position[0], unitGroupB.position[1])
        unitGroupA.offset(-1.25, 0, 0)
        unitGroupB.offset(1.25, 0, 0)
        
        var battleObj = GameObject()
        battleIDs = battleIDs + 1
        
        battleObj.addComponent(type: BattleComponent.self)
        
        var battleComp = battleObj.getComponent(type: BattleComponent.self)
        battleComp?.groupA = unitGroupA
        battleComp?.groupB = unitGroupB
        
        self.gameObject.game?.addGameObject(gameObject: battleObj)
        battleComp?.start()
    }
    
    public func powerTile(_ x: Int, _ y: Int, _ power: Int) {

        switch (power) {
        case 1:
            tileMap.getTile(x,y)!.model.color = [1.0, 0.411, 0.706, 1.0]
            break
        case 2:
            tileMap.getTile(x,y)!.model.color = [0.0, 0.0, 1.0, 1.0]
            break
        case 3:
            tileMap.getTile(x,y)!.model.color = [0.2, 0.0, 0.5, 1.0]
            break
        default:
            break
        }
    }
    
    public override func update(delta: Float) {
        super.update(delta: delta)
        
        /*followerLabel.text = String(player._followers)
        goldLabel.text = String(player._gold)
        manaLabel.text = String(player._mana)*/
    }
}
