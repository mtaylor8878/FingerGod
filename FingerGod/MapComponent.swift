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
    
    open override func create() {
        tileMap = TileMap(10,1)
       
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
                selectTile((selected?.x)! - 1, (selected?.y)! )
            }
            if str == "right" {
                selectTile((selected?.x)! + 1, (selected?.y)! )
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
            selectTile(closestTile.x, closestTile.y)
            break
        default:
            break
        }
    }
    
    public func selectTile(_ q: Int, _ r: Int) {
        if(selected != nil) {
            tileMap.getTile(q, r)?.resetColor()
        }
        selected = Point2D(q,r)
        tileMap.getTile(selected!)!.model.color = [1.0, 0.2, 0.2, 1.0]
    }

}
