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
        mi.transform = GLKMatrix4Scale(mi.transform, 0.8, 0.8, 0.8)
        Renderer.addInstance(inst: mi)
        
        self.owner = owner
        
        super.init(pos, mi)
    }
    
    public override func interact() {
        dispatchUnitGroup(size: 1)
    }
    
    private func dispatchUnitGroup(size: Int) {
        let place = HexDirections.InDirection(pos, HexDirections.RandomDirection())
        
        let unitGroup = GameObject()
        unitGroup.addComponent(type: UnitGroupComponent.self)
        owner.game?.addGameObject(gameObject: unitGroup)
        
        let unitGroupComponent = unitGroup.getComponent(type: UnitGroupComponent.self)!
        unitGroupComponent.move(place.x, place.y)
        unitGroupComponent.setAlignment(Alignment.ALLIED)
        
        owner._unitList.append(unitGroupComponent)
    }
}
