//
//  City.Swift
//  FingerGod
//
//  Created by Matthew Taylor on 2018-03-28.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class City: Structure {
    private let owner : PlayerObject
    
    public init(_ pos: Point2D, _ owner: PlayerObject) {
        var castle : Model?
        
        do {
            castle = try ModelReader.read(objPath: "Castle")
        } catch {
            print("There was a problem initializing this tile model: \(error)")
        }
        
        let mi = ModelInstance(model: castle!)
        mi.color = owner.color
        Renderer.addInstance(inst: mi)
        
        self.owner = owner
        
        super.init(pos, mi)
    }
    
    public override func interact(selected: UnitGroupComponent?) {
        if(selected == nil) {
            dispatchUnitGroup(size: 10)
        } else if(selected!.owner == owner.id!){
            returnUnits(selected!)
        }
    }
    
    private func returnUnits(_ unitGroup: UnitGroupComponent) {
        let units = unitGroup.unitGroup.peopleArray.count

        owner.removeUnit(unit: unitGroup)
        EventDispatcher.publish("SetTileType", ("pos",Point2D(unitGroup.position)), ("type", Tile.types.vacant), ("perma", false))
        unitGroup.delete()
        owner._followers += units
    }
    
    private func dispatchUnitGroup(size: Int) {
        let units = min(size, owner._followers)
        if (units > 0) {
            let shuffled = shuffleVacantTiles(tile!.getNeighbours())
            if(shuffled.count > 0) {
                let place = shuffled[Int(arc4random_uniform(UInt32(shuffled.count)))]
                let pos = place.getAxial()
                
                let unitGroup = GameObject()
                unitGroup.addComponent(type: UnitGroupComponent.self)
                owner.game?.addGameObject(gameObject: unitGroup)
                
                let unitGroupComponent = unitGroup.getComponent(type: UnitGroupComponent.self)!
                unitGroupComponent.move(pos.x, pos.y)
                unitGroupComponent.setOwner(owner)
                
                owner.addUnit(unit: unitGroupComponent)
                owner._followers -= units
                
                EventDispatcher.publish("AddUnit", ("unit", unitGroupComponent))
                
                print(String(units) + " units deployed to field")
            } else {
                print("No vacant tiles around your city!")
            }
        } else {
            print("No more followers left in base!")
        }
    }
    
    private func shuffleVacantTiles(_ tiles: [Tile]) -> [Tile] {
        var original : [Tile] = tiles
        var shuffled = [Tile]()
        while(original.count > 0) {
            let index = Int(arc4random_uniform(UInt32(original.count)))
            if(original[index].type == Tile.types.vacant) {
                shuffled.append(original[index])
            }
            original.remove(at: index)
        }
        return shuffled
    }
}
