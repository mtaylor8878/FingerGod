//
//  AIPlayer.swift
//  FingerGod
//
//  Created by Matt on 2018-04-17.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class AIPlayer : PlayerObject {
    private let map: MapComponent
    private let MOVE_CD: Float = 5.0
    private var units = [(UnitGroupComponent, Float)]()
    
    public init(_ startSpace: Point2D, map: MapComponent) {
        self.map = map

        super.init(startSpace)
    }
    
    public override func update(delta: Float) {
        super.update(delta: delta)
        
        for i in 0..<units.count {
            if(units[i].0.movePath.count == 0) {
                units[i].1 += delta
                
                if(units[i].1 >= MOVE_CD) {
                    var tile = map.getRandomTile()
                    while(tile.getType() != Tile.types.vacant) {
                        tile = map.getRandomTile()
                    }
                    
                    units[i].0.setTarget(TilePathFindingTarget(tile: tile, map: map.tileMap))
                    print("Moving enemy to (" + String(tile.getAxial().x) + ", " + String(tile.getAxial().y) + ")")
                    units[i].1 = 0
                }
            }
        }
    }
    
    public override func addUnit(unit: UnitGroupComponent) {
        super.addUnit(unit: unit)
        
        units.append((unit, 0.0))
    }
    
    public override func removeUnit(unit: UnitGroupComponent) {
        super.removeUnit(unit: unit)
        
        let index = units.index{$0.0 === unit}
        if(index != nil) {
            units.remove(at: index!)
        }
    }
}
