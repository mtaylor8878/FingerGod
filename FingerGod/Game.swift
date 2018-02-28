//
//  Game.swift
//  FingerGod
//
//  Created by Aaron F on 2018-02-15.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

/*
 The overall game
 Ties everything together and interfaces it with the ViewController
*/
public class Game {
    // The game objects within the game
    private var gameObjects = Array<GameObject>()
    // The time of the last update to be called
    private var lastTickTime = mach_absolute_time()
    // The timebase info
    private var timebaseInfo = mach_timebase_info_data_t()

    /*
     Initializes the game
     */
    public init() {
        mach_timebase_info(&timebaseInfo)
        onGameStart()
    }
    
    /*
     Adds a GameObject to the game
     When a GameObject is added to the game, all of its create methods are automatically called
     In other words, it assumes the components for the GameObject are all set up already
     */
    public func addGameObject(gameObject: GameObject) {
        gameObjects.append(gameObject)
        gameObject.create()
    }
    
    /*
     Things to be called when the game starts
    */
    
    public func onGameStart() {
    }
    
    /*
     The function that updates all of the game objects
     Runs both early and late updates
     */
    public func update() {
        let currentTickTime = mach_absolute_time()
        let timeDiff = currentTickTime - lastTickTime
        let delta = Double(timeDiff) * Double(timebaseInfo.numer) / Double(timebaseInfo.denom) / 1000000000
        lastTickTime = currentTickTime
        
        // Perform the regular updates
        for o in gameObjects {
            o.update(delta: Float(delta))
        }
        
        // Perform the late updates
        for o in gameObjects {
            o.lateUpdate(delta: Float(delta))
        }
    }
}
