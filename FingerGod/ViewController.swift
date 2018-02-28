//
//  ViewController.swift
//  FingerGod
//
//  Created by Aaron Freytag on 2018-02-15.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {

    private var i : ModelInstance!
    private var i2 : ModelInstance!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Renderer.setup(view: self.view as! GLKView)
        
        do {
            let m = try ModelReader.read(objPath: "HexTile")
            i = ModelInstance(model: m)
            
            i.transform = GLKMatrix4Translate(i.transform, -1, 0, -5.0)
            i.color = [0.2, 0.95, 0.55, 1.0]
            
            Renderer.addInstance(inst: i)
            
            i2 = ModelInstance(model: m)

            i2.transform = GLKMatrix4Translate(i2.transform, 1, 0, -5.0)
            i2.color = [0.9, 0.4, 0.2, 1.0]
            
            Renderer.addInstance(inst: i2)
        }
        catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func update() {
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        i.transform = GLKMatrix4Rotate(i.transform, Float.pi / 100, 1, 0, 0)
        i2.transform = GLKMatrix4Rotate(i2.transform, Float.pi / 100, -1, 0, 0)
        Renderer.draw(drawRect: rect)
    }

}

