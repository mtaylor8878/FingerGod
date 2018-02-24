//
//  HexMap.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-02-24.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class HexMap {

    //Number of columns
    var mapWidth : Int
    //Number of Rows
    var mapHeight : Int

    /*
     Initialize the map
     */
    public init (_ mapWidth:Int,_ mapHeight:Int) {
        self.mapWidth = mapWidth
        self.mapHeight = mapHeight
    }

    /*
     Creates the array of hexes and their coordinates
     */
    public func setTiles(columns:Int, rows:Int) -> [Hex] {
        let width = [columns]
        let height = [rows + columns / 2]
        var arrayX = [Int]()
        var arrayY = [Int]()
        var map = [Hex]()
        
        for column in width {
            arrayX.append(column)
            for row in height {
                arrayY.append(row)
                let hex = Hex([arrayX, arrayY])
                map.append(hex)
            }
        }
        return map
    }
}
