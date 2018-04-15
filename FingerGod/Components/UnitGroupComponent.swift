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
    // Positions for display purposes
    private var startPosition = [0, 0]
    private var endPosition = [0, 0]
    private var modelInst : ModelInstance?
    var unitGroup = UnitGroup.initUnitGroupWith(peopleNum:10, followerNum: 0, demiGodNum: 0)
    
    private var initShape = GLKMatrix4Scale(GLKMatrix4Identity, 0.5, 0.5, 0.5)
    public var alignment = Alignment.NEUTRAL
    
    public var movePath : [(x: Int, y: Int)] = []
    private var stepProgress : Float = 0.0
    public var moveSpeed : Float = 1.0 // Tiles per second
    
    public override func create() {
        print("Creating Unit Group")
        do {
            let model = try ModelReader.read(objPath: "CubeModel")
            modelInst = ModelInstance(model: model)
            modelInst?.transform = GLKMatrix4Translate(initShape, 0, 0.75, 0);
            modelInst?.transform = GLKMatrix4Multiply((modelInst?.transform)!, initShape)
            modelInst?.color = [1.0, 1.0, 1.0, 1.0]
            Renderer.addInstance(inst: modelInst!)
        } catch {
            print("There was a problem: \(error)")
        }
    }
    
    public override func update(delta: Float) {
        if (stepProgress <= 0.0 && movePath.count > 0) {
            endPosition[0] = movePath[0].x
            endPosition[1] = movePath[0].y
        }
        if (endPosition[0] != startPosition[0] || endPosition[1] != startPosition[1]) {
            stepProgress += moveSpeed * delta
            if (stepProgress >= 0.5) {
                EventDispatcher.publish("SetTileType", ("pos", Point2D(position)), ("type", Tile.types.vacant))
                position[0] = endPosition[0]
                position[1] = endPosition[1]
                EventDispatcher.publish("SetTileType", ("pos", Point2D(position)), ("type", Tile.types.occupied))
            }
            if (stepProgress >= 1.0) {
                // Reached our destination
                startPosition[0] = endPosition[0]
                startPosition[1] = endPosition[1]
                
                movePath.removeFirst(1)
                
                stepProgress = 0.0
            }
            updateRenderPos()
        }
    }
    
    public override func delete() {
        Renderer.removeInstance(inst: modelInst!)
    }

    public func setPosition(_ x : Int, _ y : Int) {
        EventDispatcher.publish("SetTileType", ("pos", Point2D(position)), ("type", Tile.types.vacant))
        position[0] = x
        position[1] = y
        startPosition[0] = x
        startPosition[1] = y
        endPosition[0] = x
        endPosition[1] = y
        EventDispatcher.publish("SetTileType", ("pos", Point2D(position)), ("type", Tile.types.occupied))
        updateRenderPos()
    }
    
    public func move(_ x : Int, _ y : Int) {
        movePath.append((x: x, y: y))
    }
    
    public func offset(_ x : Float, _ y : Float, _ z : Float) {
        initShape = GLKMatrix4Translate(initShape, x, y, z)
        updateRenderPos()
    }
    
    private func updateRenderPos() {
        let axs = axialToWorld(startPosition[0], startPosition[1])
        let axe = axialToWorld(endPosition[0], endPosition[1])
        let ax = (x: axs.x  * (1 - stepProgress) + axe.x * stepProgress, y: axs.y  * (1 - stepProgress) + axe.y * stepProgress)
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
}
