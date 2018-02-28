//
//  RotatingCubeComponent.swift
//  FingerGod
//
//  Created by Aaron F on 2018-02-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class RotatingCubeComponent : Component {
    private var modelInst : ModelInstance!
    open override func create() {
        do {
            let model = try ModelReader.read(objPath: "CubeModel")
            modelInst = ModelInstance(model: model)
            modelInst.color = [0.8, 0.1, 0.0, 1.0]
            Renderer.addInstance(inst: modelInst)
        } catch {
            print("There was a problem: \(error)")
        }
    }

    open override func update(delta:Float) {
        modelInst.transform = GLKMatrix4Rotate(modelInst.transform, Float.pi * delta / 2, 1.0, 0.0, 0.0)
    }
}
