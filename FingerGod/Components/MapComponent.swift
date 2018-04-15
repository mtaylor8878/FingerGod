//
//  MapComponent.swift
//  FingerGod
//
//  Created by Aaron F on 2018-02-28.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class MapComponent : Component, Subscriber {
    
    private var tileMap : TileMap!
    
    // TEMPORARY VALUES
    private var unitGroupIDs = 10000
    private var battleIDs = 100000
    private var unitGroupComps = [UnitGroupComponent]()
    
    open override func create() {
        tileMap = TileMap(10,1)
        
        EventDispatcher.subscribe("AddStructure", self)
        EventDispatcher.subscribe("SetTileColor", self)
        EventDispatcher.subscribe("SetTileType", self)
        
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
        var shortest = Float.greatestFiniteMagnitude
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
    
    public func setTileColor(tile: Point2D, color: [Float]) {
        tileMap.getTile(tile)!.model.color = color
    }
    
    public func resetTileColor(tile: Point2D){
        tileMap.getTile(tile)!.resetColor()
    }
    
    public func getTile(pos: Point2D) -> Tile? {
        return tileMap.getTile(pos)
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "AddStructure":
            let str = params["structure"]! as! Structure
            let pos = params["coords"]! as! Point2D
            tileMap.getTile(pos)?.addStructure(str)
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
            
        case "SetTileColor":
            let pos = params["pos"]! as! Point2D
            let color = params["color"] as? [Float]
            
            if(color != nil) {
                setTileColor(tile: pos, color: color!)
            } else {
                resetTileColor(tile: pos)
            }
            break
        
        case "SetTileType":
            let pos = params["pos"]! as! Point2D
            let type = params["type"]! as! Tile.types
            
            tileMap.getTile(pos)!.setType(type)
            break
            
        default:
            break
        }
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

    /*public func powerTile(_ x: Int, _ y: Int, _ power: Int) {

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
        case 4:
            tileMap.getTile(x,y)!.model.color = [1.0, 2.0, 0.2, 1.0]
            break
        default:
            break
        }
    }*/
    
    public override func update(delta: Float) {
        super.update(delta: delta)
        
        /*followerLabel.text = String(player._followers)
        goldLabel.text = String(player._gold)
        manaLabel.text = String(player._mana)*/
    }
}
