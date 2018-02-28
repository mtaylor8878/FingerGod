//
//  TileMap.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-02-24.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class TileMap {
    
    
    //Allows the passing of an x and y coordinate
    public struct Point2D: Hashable{
        var x : Int
        var y : Int
        
        public var hashValue: Int {
            return "(\(x),\(y))".hashValue
        }
        
        public static func == (lhs: Point2D, rhs: Point2D) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
    }

    //Stores the tiles in a 2d coordinate
    private var tileMap = [Point2D:Tile]()
    //Amount of columns in the map
    public var mapWidth : Int
    //Amount of rows in the map
    public var mapHeight : Int
    //Size of the tile
    public var radius :Int
    
    /*
     Initialize the map
    */
    public init(_ mapWidth:Int,_ mapHeight:Int,_ radius:Int) {
        self.mapWidth = mapWidth
        self.mapHeight = mapHeight
        self.radius = radius
        storeTiles(mapWidth, mapHeight, radius)
    }
    
    /*
     Get the number of columns
    */
    public func getWidth() -> Int {
        return self.mapWidth
    }
    
    /*
     Set the amount of columns
    */
    public func setWidth(_ newWidth:Int) {
        self.mapWidth = newWidth
    }
    
    /*
     Get the amount of rows
    */
    public func getHeight() -> Int {
        return self.mapHeight
    }
    
    /*
     Set the amount of rows
    */
    public func setHeight(_ newHeight:Int) {
        self.mapHeight = newHeight
    }
    
    /*
     Stores tiles based on the width and height of the map
    */
    public func storeTiles(_ mapWidth:Int,_ mapHeight:Int,_ radius:Int)
    {                for i in 0 ..< mapHeight {
            for j in 0 ..< mapWidth {
                tileMap[Point2D(x: i, y: j)] = Tile(radius)
            }
        }
    }
    
    /*
     Get the map
    */
    public func getTiles() -> [Point2D:Tile]{
        return self.tileMap
    }
}
 
