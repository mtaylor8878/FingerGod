//
//  FingerGodGame.swift
//  FingerGod
//
//  Created by Aaron F on 2018-02-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class FingerGodGame : Game {
    public override func onGameStart() {
        super.onGameStart()
        let map = GameObject(id: 0)
        
        map.addComponent(type: MapComponent.self)
        self.addGameObject(gameObject: map)
        
        Renderer.camera.move(x: 10, y: 20, z: -10)
        Renderer.camera.rotate(angle: -Float.pi * 2 / 6, x: 1, y: 0, z: 0)
    }
}
