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
        let power = GameObject(id: 1)
        
        map.addComponent(type: MapComponent.self)
        self.addGameObject(gameObject: map)
        power.addComponent(type: Power.self)
        self.addGameObject(gameObject: power)
        
        let player = PlayerObject(2, [0.0, 0.39, 0.898, 1.0], Point2D(0,0))
        var params = [String:Any]()
        params["structure"] = player._city!
        params["coords"] = Point2D(0,0)
        EventDispatcher.publish("AddStructure", params)
        EventDispatcher.subscribe("UpdatePlayerMana", player)
        self.addGameObject(gameObject: player)
                
        Renderer.camera.move(x: 0, y: 14, z: 9)
        Renderer.camera.rotate(angle: -Float.pi * 2 / 6, x: 1, y: 0, z: 0)
    }
}
