//
//  InputManager.swift
//  FingerGod
//
//  Created by Matt on 2018-04-13.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class InputManager : Subscriber {
    private let SELECTION_COLOR: [Float] = [1.0, 0.2, 0.2, 1.0]
    private let player: PlayerObject
    private let map: MapComponent
    
    private var selected: Point2D?
    private var currPower: Int
    
    public init(player: PlayerObject, map: MapComponent) {
        self.player = player
        self.map = map
        currPower = 0
    }
    
    public func tapScreen(coord: CGPoint) {
        let ray = getDirection(coord)
        let location = Renderer.camera.location
        let t = -location.y / ray.y
        let point = GLKVector3Add(location, GLKVector3MultiplyScalar(ray, t))
        let tile = map.getClosest(point)
        selectTile(tile.x, tile.y)
        if (currPower > 0) {
            player._mana -= 10.0
        }
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        default:
            break
        }
    }
    
    private func selectTile(_ q: Int, _ r: Int) {
        var nextObject : UnitGroupComponent? = nil
        var prevObject : UnitGroupComponent? = nil
        
        var noSelect = false
        
        if(selected != nil) {
            map.resetTileColor(tile: selected!)
            
            for c in player._unitList {
                 if c.position[0] == selected?.x && c.position[1] == selected?.y {
                     // There was a unit on our selected tile, move it to the new tile
                     prevObject = c
                 }
                 if c.position[0] == q && c.position[1] == r {
                     nextObject = c
                 }
             }
        }
        /*
         OLD CODE FOR REFERENCE
         if (prevObject != nil && prevObject!.alignment == Alignment.ALLIED) {
         if (nextObject == nil) {
         // There was a unit on our selected tile, move it to the new tile
         prevObject!.move(q, r)
         selected = nil
         return
         }
         else if (nextObject != nil && nextObject!.alignment == Alignment.ENEMY){
         // INITIATE BATTLE
         print("BATTLE START")
         startBattle(prevObject!, nextObject!)
         selected = nil
         return
         }
         }*/
        
        
        let selectedTile = map.getTile(pos: Point2D(q,r))!
        
        var output = "\n"
        output += "Selected Tile (" + String(selectedTile.getAxial().x) + ", " + String(selectedTile.getAxial().y) + ") ["
        output += "Type: " + String(describing: selectedTile.type) + ", "
        output += "World Coord: (" + String(selectedTile.worldCoordinate.x) + ", " + String(selectedTile.worldCoordinate.y) + ")"
        output += "]"
        print(output)
        
        switch(selectedTile.type) {
        case Tile.types.structure:
            selectedTile.getStructure()!.interact()
            noSelect = true
            break
        
        case Tile.types.vacant:
            if (prevObject != nil) {
                if (nextObject == nil) {
                    prevObject!.move(q, r)
                    noSelect = true
                } else if(nextObject!.alignment == Alignment.ENEMY) {
                    noSelect = true
                    // TODO: Start Battle
                }
            } else if (nextObject != nil && nextObject!.alignment == Alignment.ALLIED) {
                // TODO: display unit stuff
                noSelect = true
            }
            break
            
        default:
            break
        }
        
        if(!noSelect) {
            selected = Point2D(q,r)
            map.setTileColor(tile: selected!, color: SELECTION_COLOR)
        } else {
            selected = nil
        }
    }
    
    private func getDirection(_ loc: CGPoint) -> GLKVector3{
        let bounds = UIScreen.main.bounds
        let x = Float((2 * loc.x) / bounds.size.width - 1.0)
        let y = Float(1.0 - (2 * loc.y) / bounds.size.height)
        let rayClip = GLKVector4Make(x, y, -1.0, 1.0)
        let invPerspective = GLKMatrix4Invert(Renderer.perspectiveMatrix, nil)
        var rayEye = GLKMatrix4MultiplyVector4(invPerspective, rayClip)
        rayEye.z = -1.0
        rayEye.a = 0
        let rayWorld = GLKMatrix4MultiplyVector4(Renderer.camera.transform, rayEye)
        let rayWNorm = GLKVector3Normalize(GLKVector3Make(rayWorld.x, rayWorld.y, rayWorld.z))
        return rayWNorm
    }
}
