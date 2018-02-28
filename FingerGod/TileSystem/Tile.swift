//
//  Tile.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-02-24.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

/*
 Tile Class for the tiles that make up the map
 */
public class Tile {
    
    //Types of tiles
    public enum types {
        case vacant
        case occupied
        case boundary
        case structure
    }

    //Neighbouring Tile Coordinates
    private let neighboursX : [Int] = [0, 1, 1, 0, -1, -1]
    private let neighboursY : [[Int]] = [[-1, -1, 0, 1, 0, -1], [-1, 0, 1, 1, 1, 0]]
    
    //Tile Corner Coordinates
    private let cornerX : [Int]
    private let cornerY : [Int]
    
    //Tile Side
    private let side : Int
    
    //Tile Left Coordinate
    private var coordI : Int
    //Tile Top Coordinate
    private var coordJ : Int
    //Tile X Index
    private var coordX : Int
    //Tile Y Index
    private var coordY : Int
    
    //Tile Dimensions
    public let radius : Int
    public let height : Int
    public let width : Int
    //Number of Neigbours / Sides
    public let neighbours : Int = 6
    //Type of Tile
    public var type : types
    
    /*
     Initialize a tile using a radius
    */
    public init(_ radius:Int) {
        self.radius = radius
        width = radius * 2
        height = radius * (Int(sqrt(3)))
        side = radius * 3 / 2
        cornerX = [radius / 2, side, width, side, radius / 2, 0]
        cornerY = [0, 0, height / 2, height, height, height / 2]
        type = types.vacant
        
        coordI = 0
        coordJ = 0
        coordX = 0
        coordY = 0
    }
    
    /*
     Get the Left Coord
    */
    public func getI() -> Int {
        return coordI
    }
    
    /*
     Get the Top Coord
    */
    public func getJ() -> Int {
        return coordJ
    }
    
    /*
     Get the X coord of the center
    */
    public func getCenterX() -> Int {
        return coordI * radius
    }
    
    /*
     Get the Y coord of the center
    */
    public func getCenterY() -> Int {
        return coordJ * radius
    }
    
    /*
     Get the X index
    */
    public func getCoordX() -> Int {
        return coordX
    }
    
    /*
     Get the Y index
    */
    public func getCoordY() -> Int {
        return coordY
    }
    
    /*
     Get a the X Coord of a neighour
    */
    public func getNeighbourX(_ neighbourX:Int) -> Int {
        return coordX + neighboursX[neighbourX]
    }
   
    /*
     Get the Y Coord of a neighbour
    */
    public func getNeighbourY(_ neighbourY:Int) -> Int {
        return coordY + neighboursY[coordX % 2][neighbourY]
    }
    
    /*
     Sets the 6 corners of the Tile
    */
    public func setCorners(_ cornersX: inout [Int],_ cornersY: inout [Int]) {
        for i in 0 ..< neighbours {
            cornersX[i] = coordI + cornerX[i]
            cornersY[i] = coordJ + cornerY[i]
        }
    }
    
    /*
     Sets the the Indexes of the tile
    */
    public func setCellIndex(_ x:Int,_ y:Int) {
        coordX = x;
        coordY = y;
        coordI = x * side;
        coordJ = height * (2 * y + (x % 2)) / 2
    }
    
    /*
     Sets the Tile as a Point
    */
    public func setCellByPoint(_ x:Int,_ y:Int) {
        let indexI = Int(floor(Float(x) / Float(side)))
        let indexX = x - side * indexI
        
        let tempY = y - (indexI % 2) * height / 2
        let indexJ = Int(floor(Float(tempY) / Float(height)))
        let indexY = tempY - height * indexJ
        
        if (indexX > abs((radius / 2 - radius * indexY / height))) {
            setCellIndex(indexI, indexJ)
        } else {
            setCellIndex(indexI - 1, indexJ + (indexI % 2) - ((indexY < height / 2) ? 1 : 0))
        }
    }
    
    /*
     Get the type of the tile
    */
    public func getType() -> types {
        return self.type
    }
    
    /*
     Set the type of the tile
    */
    public func setType(_ newType:types) {
        self.type = newType
    }
}

