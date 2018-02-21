//
//  Hex.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-02-19.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

/*
 Hex Class for the tiles that make up the map
 */
public class Hex {
    
    //Types of tiles
    public enum types {
        case vacant
        case occupied
        case boundary
        case structure
    }
    
    //Tile location
    var coordinates = [[Int]]()
    //Tile type
    var type : types
    //Tile neighbour and respective type. 6 neighbours to one tile
    var neighbours = [Hex]()
    
    //Direction of neighbouring tiles
    var axialDir = [[0, -1], [+1, -1], [+1, 0], [0, +1], [-1, +1], [-1, 0]]
    
    /*
    Initialize a Hex tile
    */
    public init (_ coordinates:[[Int]],_ type:types,_ neighbours:[Hex]) {
        self.coordinates = coordinates
        self.type = type
        self.neighbours = neighbours
    }
    
    public init (_ coordinates:[[Int]]) {
        self.coordinates = coordinates
        type = types.vacant
        neighbours = [Hex]()
    }
    
    /*
    Get the hex tile using a coordinate
    */
    public func getHex(_ hex:[[Int]]) -> Hex {
        coordinates = hex;
        let targetTile = Hex(coordinates)
        return targetTile
    }
    
    /*
     Set the tiles type
    */
    public func setType(hex:[[Int]], tileType:types) {
        let targetTile = getHex(hex)
        targetTile.type = tileType
    }
    
    func getCoordinates(_ hex:Hex) -> [Int] {
        let firstArray = hex.coordinates[0]
        let secondArray = hex.coordinates[1]
        let targetCoord = [firstArray[0], secondArray[0]]
        return targetCoord
    }
    
    func hexDirection(_ direction:Int) -> [Int] {
        return axialDir[direction]
    }
    
    func getNeighbour(hex:Hex, direction:Int) -> Hex {
        let dir = hexDirection(direction)
        let dir1 = dir[0]
        let dir2 = dir[1]
        
        let yourTile = getCoordinates(hex)
        let yourTile1 = yourTile[0]
        let yourTile2 = yourTile[1]
        return Hex([[dir1 + yourTile1],[dir2 + yourTile2]])
    }

}

