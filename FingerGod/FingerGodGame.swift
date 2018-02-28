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
        let sampleObj = GameObject(id: 0)
        
        sampleObj.addComponent(type: RotatingCubeComponent.self)
        self.addGameObject(gameObject: sampleObj)
        
        Renderer.camera.move(x: 0, y: 0, z: 5)
    }
}
