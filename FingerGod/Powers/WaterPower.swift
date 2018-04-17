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
        for c in (unitGroupManager?.unitGroups)! {
            if c.position[0] == tile.getAxial().x && c.position[1] == tile.getAxial().y {
                for u in (c.unitGroup.peopleArray) {
                    let unit = u as! SingleUnit
                    unit.heal(damage: 50)
                }
            }
        }
        tile.model.color = [0.0, 0.0, 1.0, 1.0]
    }
    
    public override func update(delta: Float) {
        
    }
}
