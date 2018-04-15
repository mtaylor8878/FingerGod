//
//  TitleController.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-04-11.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import UIKit
import GLKit

class TitleController: GLKViewController, Subscriber {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Renderer.setup(view: self.view as! GLKView)
        
        var castle : Model?
        
        do {
            castle = try ModelReader.read(objPath: "Castle")
        } catch {
            print("There was a problem initializing this tile model: \(error)")
        }
        
        let mi = ModelInstance(model: castle!)
        Renderer.addInstance(inst: mi)
    }
    
    func update() {
        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        super.glkView(view, drawIn: rect)

        Renderer.draw(drawRect: rect)
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
    
    }
}
