//
//  WaterPower.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-04-13.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import UIKit

public class WaterPower : Power {
    
    var target : UnitGroupComponent?
    
    public override init(player: PlayerObject) {
        super.init(player: player)
        _btn = RoundButton.init()
        _btn?.cornerRadius = 25
        _btn?.borderWidth = 1
        _btn?.borderColor = UIColor.blue
        _btn?.addTarget(self, action: #selector(waterTap), for: UIControlEvents.touchUpInside)
    }
    
    @objc func waterTap() {
        _player._curPower = self
    }
    public override func activate(tile : Tile) {
        EventDispatcher.publish("HealUnit", ("tile", tile), ("heal", 50))
        tile.model.color = [0.0, 0.0, 1.0, 1.0]
    }
    
    public override func update(delta: Float) {
        
    }
}
