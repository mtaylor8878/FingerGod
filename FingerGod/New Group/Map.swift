//
//  Map.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-02-19.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

/*
 The group of tiles making up the world
 */
public class Map {
    
    //The amount of tiles. A 2d array.
    var mapSize : [[Int]]
    
    /*
     Initialize the map
    */
    public init (mapWidth:Int, mapLength:Int) {
        self.mapSize = [[mapWidth], [mapLength]]
    }
    
    public func setTiles() {
        
    }
}
