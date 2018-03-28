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

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeigh = UIScreen.main.bounds.size.height

class ViewController: GLKViewController {
    
    private var game : Game!
    private var prevPanPoint = CGPoint(x: 0, y: 0)
    private var prevScale : Float = 1
    var player = PlayerObject(newId : 0)
    var count : Int = 0;

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var gold: UILabel!
    @IBOutlet weak var mana: UILabel!
    @IBAction func onButtonClick(_ sender: RoundButton) {
        let powers = ["Off", "fire", "water", "lightning", "earth"];
        var powerSelected = [String : Any]();
        powerSelected["power"] = powers[count];
        EventDispatcher.publish("PowerOn", powerSelected);
        
        count += 1;
        if (count == 5) {
            count = 0;
        }
        label.text = powers[count];
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loadisg the view, typically from a nib.
        Renderer.setup(view: self.view as! GLKView)
        label.text = "Off"
        game = FingerGodGame()
        self.initButton()
        followers.text = String(player._followers)
        gold.text = String(player._gold)
        mana.text = String(player._mana)

    }
    @IBAction func onTap(_ recognizer: UITapGestureRecognizer) {
        let ray = getDirection(recognizer.location(in: self.view))
        let location = GLKVector3Make(Renderer.camera.transform.m30, Renderer.camera.transform.m31, Renderer.camera.transform.m32)
        print("location: " + String(location.x) + ", " + String(location.y) + ", " + String(location.z))
        let t = -location.y / ray.y
        let point = GLKVector3Add(location, GLKVector3MultiplyScalar(ray, t))
        var paramList = [String : Any]()
        paramList["coord"] = point
        paramList["power"] = count
        if (count > 0) {
            player._mana -= 10
            mana.text = String(player._mana)
        }
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
    func initButton() {
        let btn = UIButton.init()
        btn.frame = CGRect.init(x: ScreenWidth - 200, y: 100, width: 200, height: 50)
        btn.setTitle("addUnitGroup", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        /*
        let leftBtn = UIButton.init()
        leftBtn.frame = CGRect.init(x: ScreenWidth - 200, y: 150, width: 200, height: 50)
        leftBtn.setTitle("leftMoveUnitGroup", for: .normal)
        leftBtn.setTitleColor(UIColor.blue, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftMoveBtnClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(leftBtn)
        let rightBtn = UIButton.init()
        rightBtn.frame = CGRect.init(x: ScreenWidth - 200, y: 200, width: 200, height: 50)
        rightBtn.setTitle("rightMoveUnitGroup", for: .normal)
        rightBtn.setTitleColor(UIColor.blue, for: .normal)
        rightBtn.addTarget(self, action: #selector(rightMoveBtnClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(rightBtn)
        */
        
    }
    
    @objc func btnClick() {
        self.initPoint(x: 115, y: 243)
    }
    @objc func leftMoveBtnClick() {
        let dic = NSDictionary.init(object: "left", forKey: "direction" as NSCopying)
        EventDispatcher.publish("moveGroupUnit", dic as! [String : Any])
    }
    @objc func rightMoveBtnClick() {
        let dic = NSDictionary.init(object: "right", forKey: "direction" as NSCopying)
        EventDispatcher.publish("moveGroupUnit", dic as! [String : Any])
    }
    func initPoint(x:NSInteger,y:NSInteger)  {
        let ray = getDirection(CGPoint.init(x: x, y: y))
        let t = -Renderer.camera.location.y / ray.y
        
        let point = GLKVector3Add(Renderer.camera.location, GLKVector3MultiplyScalar(ray, t))
        var paramList = [String : Any]()
        paramList["coord"] = point
        EventDispatcher.publish("DispatchUnitGroup", paramList)
    }


}

