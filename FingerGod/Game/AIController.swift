//
//  AIController.swift
//  FingerGod
//
//  Created by Matthew Taylor on 2018-04-14.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class AIController : GameObject {
    private var AIPlayers: [AIPlayer]
    private var map: MapComponent
    
    public init(map: MapComponent) {
        AIPlayers = [AIPlayer]()
        self.map = map
        super.init()
    }
    
    public func setup(numEnemies: Int) {
        for _ in 1...numEnemies {
            var start = map.getRandomTile()
            while(start.getType() != Tile.types.vacant) {
                start = map.getRandomTile()
            }
            let player = AIPlayer(start.getAxial(), map: map)
            game!.addGameObject(gameObject: player)
            
            AIPlayers.append(player)
            
            player._city!.interact(selected: nil)
        }
    }
    
    private func takeEnemyTurn() {
        
    }
}
