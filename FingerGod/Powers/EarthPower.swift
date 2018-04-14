//
//  EarthPower.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-04-13.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation


public class EarthPower : Power {
    
    var target : Tile?
    
    public override func update(delta: Float) {
        target?.setType(Tile.types.boundary)
    }
}
