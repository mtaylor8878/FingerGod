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
    private var unitGroupManager : UnitGroupManager
    
    private var selected: Point2D?
    private var currPower: Int
    private var powerMenuEnabled : Bool
    private var powerMenu : [RoundButton]
    
    public init(player: PlayerObject, map: MapComponent, unitGroupManager: UnitGroupManager) {
        self.player = player
        self.map = map
        self.unitGroupManager = unitGroupManager
        currPower = 0
        powerMenuEnabled = false
        powerMenu = [RoundButton]()
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
    
    public func togglePowerMenu() {
        powerMenuEnabled = !powerMenuEnabled
        
        if (powerMenuEnabled) {
            var pos : Int
            pos = 0
            for power in player.powers {
                pos += 20
                EventDispatcher.publish("AddPowerButton", ("button", power._btn!), ("pos", pos))
            }
        } else {
            player.powers.removeAll()
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
            
            for c in unitGroupManager.unitGroups {
                 if c.position[0] == selected?.x && c.position[1] == selected?.y {
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
        output += "\n"
        print(output)
        
        if (player._curPower != nil) {
            player._curPower?.activate(tile: selectedTile)
            player._curPower = nil
        }
        
        switch(selectedTile.type) {
        case Tile.types.structure:
            selectedTile.getStructure()!.interact(selected: prevObject)
            noSelect = true
            break
        
        case Tile.types.vacant:
            if (prevObject != nil) {
                if (nextObject == nil) {
                    prevObject!.move(q, r)
                    noSelect = true
                }
            }
            break
            
        case Tile.types.occupied:
            if (nextObject != nil) {
                if(nextObject!.alignment == Alignment.ALLIED) {
                    print("Ally Selected")
                    // TODO: display unit stuff
                    let peopleNum = nextObject?.unitGroup.peopleArray.count
                    print("Units in tile "  + String(describing: peopleNum))
                    EventDispatcher.publish("AllyClick", ("unitCount", peopleNum ?? 0))
                    noSelect = true
                } else if(nextObject!.alignment == Alignment.ENEMY){
                    print("Enemy Selected")
                    // Note: Battle doesn't start here, we simply move to the tile
                    // But in future, may want to have the player start moving to the "enemy" rather than its tile
                    if (prevObject != nil) {
                        prevObject!.move(q, r)
                        noSelect = true
                    }
                }
            }
            
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
