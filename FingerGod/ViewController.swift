//
//  ViewController.swift
//  FingerGod
//
//  Created by Aaron Freytag on 2018-02-15.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import UIKit
import GLKit

class ViewController: GLKViewController {
    
    private var game : Game!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Renderer.setup(view: self.view as! GLKView)

        game = FingerGodGame()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
    }
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        super.glkView(view, drawIn: rect)
        game.update()
        Renderer.draw(drawRect: rect)
    }

}

