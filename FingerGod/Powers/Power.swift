//
//  Power.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-03-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class Power : GameObject{
    
    public var _player : PlayerObject
    public var _tick : Float
    public var unitGroupManager : UnitGroupManager?
    public var _btn : RoundButton?
    
    public init(player: PlayerObject) {
        _player = player
        _tick = 2.0
        super.init()
    }
    
    public func activate(tile : Tile) {
        
    }
    
    public override func update(delta: Float) {
        
    }
    
}
