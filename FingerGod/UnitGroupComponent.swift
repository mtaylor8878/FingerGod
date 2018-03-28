//
//  UnitGroupComponent.swift
//  FingerGod
//
//  Created by Aaron F on 2018-03-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class UnitGroupComponent : Component {
    // Axial coordinate position
    private var position = [0, 0]
    private var modelInst : ModelInstance?
    private var unitGroup = UnitGroup.initUnitGroupWith(peopleNum:10, followerNum: 0, demiGodNum: 0)
    
    private var initShape = GLKMatrix4Scale(GLKMatrix4Identity, 0.5, 0.5, 0.5)
    private var alignment = Alignment.NEUTRAL
    
    public override func create() {
        print("Creating Unit Group")
        do {
            let model = try ModelReader.read(objPath: "CubeModel")
            modelInst = ModelInstance(model: model)
            modelInst?.transform = GLKMatrix4Translate(initShape, 0, 0.75, 0);
            modelInst?.color = [1.0, 1.0, 1.0, 1.0]
            Renderer.addInstance(inst: modelInst!)
        } catch {
            print("There was a problem: \(error)")
        }
    }
    
    public func move(_ x : Int, _ y : Int) {
        position[0] = x
        position[1] = y
        
        let ax = axialToWorld(x, y)
        
        modelInst?.transform = GLKMatrix4Translate(initShape, ax[0], 0.75, -ax[1]);
    }
    
    public func setAlignment(_ alignment: Alignment) {
        self.alignment = alignment;
        switch(alignment) {
        case Alignment.NEUTRAL:
            modelInst?.color = [1.0, 1.0, 1.0, 1.0]
            break
        case Alignment.ALLIED:
            modelInst?.color = [0.0, 0.2, 1.0, 1.0]
            break
        case Alignment.ENEMY:
            modelInst?.color = [1.0, 0.2, 0.0, 1.0]
            break
        }
    }
    
    // My own function for converting from axial coordinates to a world position
    private func axialToWorld(_ ax: Int, _ ay: Int) -> [Float] {
        let dist = Float(3).squareRoot();
        var result = [Float]()
        
        result.append(dist * cos(Float.pi / 6) * Float(ax)) // x value
        result.append(dist * sin(Float.pi / 6) * Float(ax) + dist * Float(ay)) // y value
        
        return result
    }
}
