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
    private var unitMenuHide : Bool = false

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var FollowerLabel: UILabel!
    @IBOutlet weak var GoldLabel: UILabel!
    @IBOutlet weak var ManaLabel: UILabel!
    var Exit: RoundButton!
    var Split: UIButton!
    
    @IBAction func onButtonClick(_ sender: RoundButton) {
        // Power Button
        
        /*let powers = ["Off", "fire", "water", "lightning", "earth"];
        var powerSelected = [String : Any]();
        powerSelected["power"] = powers[count];
        EventDispatcher.publish("PowerOn", powerSelected);
        
        count += 1;
        if (count == 4) {
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
        self.initButton()
        self.unitMenu()
        EventDispatcher.subscribe("UpdatePlayerUI", self)
        EventDispatcher.subscribe("AllyClick", self)
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

    func unitMenu() {
        Exit = RoundButton.init()
        Exit.frame = CGRect.init(x: ScreenWidth - 110, y: 345, width: 15, height: 15)
        Exit.cornerRadius = 7.5
        Exit.borderWidth = 1
        Exit.borderColor = UIColor.red
        Exit.setTitle("X", for: .normal)
        Exit.setTitleColor(UIColor.red, for: .normal)
        Exit.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 6)
        Exit.addTarget(self, action: #selector(exitMenu), for: UIControlEvents.touchUpInside)
        self.view.addSubview(Exit)
        
        Split = UIButton.init()
        Split.frame = CGRect.init(x: ScreenWidth - 150, y: 300, width: 100, height: 30)
        Split.setTitle("Split Group", for: .normal)
        Split.setTitleColor(UIColor.blue, for: .normal)
        Split.backgroundColor = UIColor.lightGray
        self.view.addSubview(Split)
 
    }
    
    @objc func exitMenu() {
        Exit.isHidden = true;
        Split.isHidden = true;
        
        NSLog("unitMenu: " + String(unitMenuHide) + " exit: " + String(Exit.isHidden))

    }

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

