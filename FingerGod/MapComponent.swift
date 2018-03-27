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
    
    private var tilemap : TileMap!
    private var tileModelInsts : [TileMap.Point2D : ModelInstance]!
    private var selected: TileMap.Point2D?
    
    open override func create() {
        tilemap = TileMap(30, 30, 1)
        do {
            let model = try ModelReader.read(objPath: "HexTile")
            let tiles = tilemap.getTiles()
            tileModelInsts = [TileMap.Point2D : ModelInstance]()
            
            for x in 0..<tilemap.getWidth() {
                for y in 0..<tilemap.getHeight() {
                    let tile = tiles[TileMap.Point2D(x: x, y: y)]!
                    tile.setCellByPoint(x, y)
                    let pos = self.axialToWorld(x, y)
                    var mi = ModelInstance(model: model)
                    mi.color = [0.075, Float(0.85 + (x % 2 == 0 ? 0 : 0.15)), 0.25 + Float(y % 2 == 0 ? 0 : 0.15), 1.0]
                    mi.transform = GLKMatrix4Translate(mi.transform, pos[0], 0, -pos[1])
                    
                    mi.transform = GLKMatrix4RotateX(mi.transform, -Float.pi/2)
                    
                    tileModelInsts[TileMap.Point2D(x: x, y: y)] = mi
                    Renderer.addInstance(inst: mi)
                }
            }
        } catch {
            print("There was a problem: \(error)")
        }
       
        EventDispatcher.subscribe("ClickMap",self)
        EventDispatcher.subscribe("moveGroupUnit",self)

    }
    
    public func getClosest(_ coord: GLKVector3) -> TileMap.Point2D {
        let tiles = tilemap.getTiles()
        var shortest = Float(255)
        var select: TileMap.Point2D!
        
        for x in 0..<tilemap.getWidth() {
            for y in 0..<tilemap.getHeight() {
                let tile = tiles[TileMap.Point2D(x: x, y: y)]!
                let point = axialToWorld(x,y)
                let tileCoord = GLKVector3Make(Float(point[0]), 0, Float(-point[1]))
                let dist = GLKVector3Distance(tileCoord, coord)
                if dist < shortest {
                    shortest = dist
                    select = TileMap.Point2D(x: x, y: y)
                }
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
            let tiles = tilemap.getTiles()
            let point = params["coord"] as! GLKVector3
            let closestTile = getClosest(point)
            let tile = tiles[closestTile]!
            var outputString = "\nPoint: (" + String(point.x) + "," + String(point.y) + "," + String(point.z) + ")"
            outputString += "\nTile Axial: (" + String(closestTile.x) + "," + String(closestTile.y) + ")"
            outputString += "\nTile World: (" + String(tile.getCenterX()) + "," + String(tile.getCenterY()) + ")"
            NSLog(outputString)
            selectTile(closestTile.x, closestTile.y)
            break
        default:
            break
        }
    }
    
    public func selectTile(_ x: Int, _ y: Int) {
        if(selected != nil) {
            
            var curr = tileModelInsts[selected!]!
            curr.color = [0.075, Float(0.85 + (selected!.x % 2 == 0 ? 0 : 0.15)), 0.25 + Float(selected!.y % 2 == 0 ? 0 : 0.15), 1.0]
        }
        selected = TileMap.Point2D(x:x,y:y)
        tileModelInsts[selected!]!.color = [1.0, 0.2, 0.2, 1.0]
    }
    
    // My own function for converting from axial coordinates to a world position
    private func axialToWorld(_ ax: Int, _ ay: Int) -> [Float] {
        let dist = Float(3).squareRoot();
        var result = [Float]()
        
        result.append(dist * cos(Float.pi / 6) * Float(ax)) // x value
        result.append(dist * sin(Float.pi / 6) * Float(ax) + dist * Float(ay)) // y value
        
        return result
    }
}
