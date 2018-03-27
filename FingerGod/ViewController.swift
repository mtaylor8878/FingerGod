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
    private var prevPanPoint = CGPoint(x: 0, y: 0)
    private var prevScale : Float = 1

    
    @IBOutlet weak var label: UILabel!
    @IBAction func onButtonClick(_ sender: Any) {
        let powers = ["fire", "water", "lightning", "earth"];
        var count = 0;
        
        if (count > 4) {
            count = 0;
        }
        label.text = powers[count];
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loadisg the view, typically from a nib.
        Renderer.setup(view: self.view as! GLKView)

        game = FingerGodGame()

    }
    @IBAction func onTap(_ recognizer: UITapGestureRecognizer) {
        let ray = getDirection(recognizer.location(in: self.view))
        let location = GLKVector3Make(Renderer.camera.transform.m30, Renderer.camera.transform.m31, Renderer.camera.transform.m32)
        print("location: " + String(location.x) + ", " + String(location.y) + ", " + String(location.z))
        let t = -location.y / ray.y
        let point = GLKVector3Add(location, GLKVector3MultiplyScalar(ray, t))
        var paramList = [String : Any]()
        paramList["coord"] = point
        EventDispatcher.publish("ClickMap", paramList)
    }
    
    @IBAction func onPan(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.began) {
            prevPanPoint = CGPoint(x: 0, y: 0)
        }
        let point = recognizer.translation(in: self.view)
        let diff = CGPoint(x: point.x - prevPanPoint.x, y: point.y - prevPanPoint.y)
        prevPanPoint = point
        
        let w = UIScreen.main.bounds.size.width
        Renderer.camera.move(x: Float(-diff.x * 10 / w), y: 0, z: Float(-diff.y * 10 / w))
    }
    
    @IBAction func onPinch(recognizer: UIPinchGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.began) {
            prevScale = 1
        }
        let scale = Float(recognizer.scale)
        let diff = scale - prevScale
        prevScale = scale;
        
        Renderer.camera.moveRelative(x: 0, y: 0, z: -diff * 4)
    }
    
    func getDirection(_ loc: CGPoint) -> GLKVector3{
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

