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

class ViewController: GLKViewController, Subscriber {
    
    private var game : Game!
    private var prevPanPoint = CGPoint(x: 0, y: 0)
    private var prevScale : Float = 1

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var FollowerLabel: UILabel!
    @IBOutlet weak var GoldLabel: UILabel!
    @IBOutlet weak var ManaLabel: UILabel!
    
    @IBAction func onButtonClick(_ sender: RoundButton) {
        // Power Button
        
        /*let powers = ["Off", "fire", "water", "lightning", "earth"];
        var powerSelected = [String : Any]();
        powerSelected["power"] = powers[count];
        EventDispatcher.publish("PowerOn", powerSelected);
        
        count += 1;s
        if (count == 5) {
            count = 0;
        }
        label.text = powers[count];*/
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loadisg the view, typically from a nib.
        Renderer.setup(view: self.view as! GLKView)
        label.text = "Off"
        game = FingerGodGame()
        EventDispatcher.subscribe("UpdatePlayerUI", self)
    }
    
    @IBAction func onTap(_ recognizer: UITapGestureRecognizer) {
        game.input!.tapScreen(coord: recognizer.location(in: self.view))
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
    /*func initButton() {
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
        
    }*/
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch(eventName) {
        case "UpdatePlayerUI":
            FollowerLabel.text = (params["Followers"]! as! String)
            GoldLabel.text = (params["Gold"]! as! String)
            ManaLabel.text = (params["Mana"]! as! String)
            break
        default:
            break
        }
    }


}

