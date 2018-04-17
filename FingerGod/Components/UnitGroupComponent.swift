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
    public var position = [0, 0]
    private var model : Model?
    private var unitModels = [ModelInstance]()
    private var modelInst : ModelInstance?
    private var squareSize = 0
    var unitGroup = UnitGroup.initUnitGroupWith(peopleNum:10, followerNum: 0, demiGodNum: 0)
    
    private var initShape = GLKMatrix4Scale(GLKMatrix4Identity, 0.5, 0.5, 0.5)
    public var alignment = Alignment.NEUTRAL
    
    public override func create() {
        print("Creating Unit Group")
        do {
            model = try ModelReader.read(objPath: "CubeModel")
            updateModels()
        } catch {
            print("There was a problem: \(error)")
        }
    }
    
    public override func delete() {
        Renderer.removeInstance(inst: modelInst!)
    }
    
    public func move(_ x : Int, _ y : Int) {
        let oldPos = position
        position[0] = x
        position[1] = y
        EventDispatcher.publish("UnitMoved", ("newPos", Point2D(position)), ("oldPos", Point2D(oldPos)), ("unit", self))
        
        updateRenderPos()
    }
    
    public func offset(_ x : Float, _ y : Float, _ z : Float) {
        initShape = GLKMatrix4Translate(initShape, x, y, z)
        updateRenderPos()
    }
    
    private func updateRenderPos() {
        let ax = axialToWorld(position[0], position[1])
        modelInst?.transform = GLKMatrix4Translate(GLKMatrix4Identity, ax.x, 0.75, ax.y)
        modelInst?.transform = GLKMatrix4Multiply((modelInst?.transform)!, initShape)
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
    
    private func axialToWorld(_ q: Int, _ r: Int) -> (x: Float, y: Float) {
        let x = 3.0 / 2.0 * Float(q) // x value
        let z = Float(3).squareRoot() * (Float(r) + Float(q) / 2) // z value
        
        return (x,z)
    }
    
    private func updateModels() {
        modelInst = ModelInstance(model: model!)
        modelInst?.transform = GLKMatrix4Translate(initShape, 0, 0.75, 0);
        modelInst?.transform = GLKMatrix4Multiply((modelInst?.transform)!, initShape)
        modelInst?.color = [1.0, 1.0, 1.0, 1.0]
        Renderer.addInstance(inst: modelInst!)
    }
}
