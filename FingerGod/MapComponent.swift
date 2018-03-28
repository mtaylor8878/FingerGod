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
    private var selected: Point2D?
    private var player: PlayerObject!
    
    open override func create() {
        tileMap = TileMap(10,1)
        
        player = PlayerObject(2, tileMap.getTile(0,0)!)
        
       
        EventDispatcher.subscribe("ClickMap",self)
        EventDispatcher.subscribe("moveGroupUnit",self)
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
        default:
            break
        }
    }
    
    public func selectTile(_ q: Int, _ r: Int) {
        if(selected != nil) {
            tileMap.getTile(selected!)?.resetColor()
        }
        selected = Point2D(q,r)
        tileMap.getTile(selected!)!.model.color = [1.0, 0.2, 0.2, 1.0]
    }
    
    public func powerTile(_ x: Int, _ y: Int, _ power: Int) {
        /*
        if(selected != nil) {
            
            var curr = tileModelInsts[selected!]!
            curr.color = [0.075, Float(0.85 + (selected!.x % 2 == 0 ? 0 : 0.15)), 0.25 + Float(selected!.y % 2 == 0 ? 0 : 0.15), 1.0]
        }

        selected = TileMap.Point2D(x:x,y:y)
*/
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
    }
}
