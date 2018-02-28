//
//  MapComponent.swift
//  FingerGod
//
//  Created by Aaron F on 2018-02-28.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class MapComponent : Component {
    private var tilemap : TileMap!
    private var tileModelInsts : [ModelInstance]!
    
    open override func create() {
        tilemap = TileMap(30, 30, 1)
        do {
            let model = try ModelReader.read(objPath: "HexTile")
            let tiles = tilemap.getTiles()
            tileModelInsts = [ModelInstance]()
            
            for x in 0..<tilemap.getWidth() {
                for y in 0..<tilemap.getHeight() {
                    let tile = tiles[TileMap.Point2D(x: x, y: y)]!
                    tile.setCellByPoint(x, y)
                    let pos = self.axialToWorld(x, y)
                    var mi = ModelInstance(model: model)
                    mi.color = [0.075, Float(0.85 + (x % 2 == 0 ? 0 : 0.15)), 0.25 + Float(y % 2 == 0 ? 0 : 0.15), 1.0]
                    mi.transform = GLKMatrix4Translate(mi.transform, pos[0], 0, -pos[1])
                    
                    mi.transform = GLKMatrix4RotateX(mi.transform, -Float.pi/2)
                    
                    tileModelInsts.append(mi)
                    Renderer.addInstance(inst: mi)
                }
            }
        } catch {
            print("There was a problem: \(error)")
        }
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
