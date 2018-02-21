//
//  TileSystem.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-02-18.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class TileSystem {
    
    public var tileSize : Float
    public var mapSize :Int

    struct Map {
        var tiles : [Hex];
    }
    
    public init(mapSize:Int, tileSize:Float) {
        self.mapSize = mapSize
        self.tileSize = tileSize
    }
    
}
