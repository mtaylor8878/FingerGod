//
//  FirePower.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-04-13.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import UIKit

public class FirePower : Power {
    
    var target : UnitGroupComponent?
    
    public override init(player: PlayerObject) {
        super.init(player: player)
        _btn = RoundButton.init()
        _btn?.cornerRadius = 25
        _btn?.borderWidth = 1
        _btn?.borderColor = UIColor.red
        _btn?.addTarget(self, action: #selector(fireTap), for: UIControlEvents.touchUpInside)
    }
    
    @objc func fireTap() {
        _player._curPower = self
    }
    
    public override func activate(tile : Tile){
        EventDispatcher.publish("DamageUnit", ("tile", tile), ("damage", 50))
        tile.model.color = [1.0, 0.411, 0.706, 1.0]
    }
    
    public override func update(delta: Float) {

    }
}
