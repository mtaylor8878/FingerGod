//
//  FingerGodGame.swift
//  FingerGod
//
//  Created by Aaron F on 2018-02-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class FingerGodGame : Game {
    private var unitGroupManager : UnitGroupManager?
    public override func onGameStart() {
        super.onGameStart()
        
        let map = GameObject()
        map.addComponent(type: MapComponent.self)
        self.addGameObject(gameObject: map)
        
        let player = PlayerObject([0.0, 0.39, 0.898, 1.0], Point2D(0,0))
        self.addGameObject(gameObject: player)
        
        unitGroupManager = UnitGroupManager(self, map.getComponent(type: MapComponent.self)!)
        input = InputManager(player: player, map: map.getComponent(type: MapComponent.self)!, unitGroupManager: unitGroupManager!)
        
        map.getComponent(type: MapComponent.self)!.generate()
                
        Renderer.camera.move(x: 0, y: 14, z: 9)
        Renderer.camera.rotate(angle: -Float.pi * 2 / 6, x: 1, y: 0, z: 0)
    }
}
