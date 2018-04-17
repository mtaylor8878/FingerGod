//
//  EarthPower.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-04-13.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import UIKit

public class EarthPower : Power {
    
    var target : Tile?
    
    public override init(player: PlayerObject) {
        super.init(player: player)
        _btn = RoundButton.init()
        _btn?.cornerRadius = 25
        _btn?.borderWidth = 1
        _btn?.borderColor = UIColor.yellow
        _btn?.addTarget(self, action: #selector(earthTap), for: UIControlEvents.touchUpInside)
    }
    
    @objc func earthTap() {
        _player._curPower = self
    }
    public override func activate(tile : Tile) {
        tile.setType(Tile.types.boundary)
        tile.model.color = [1.0, 1.0, 0.0, 1.0]
    }
    
    public override func update(delta: Float) {
        
    }
}
