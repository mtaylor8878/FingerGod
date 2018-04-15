//
//  Power.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-03-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class Power : GameObject, Subscriber {
    
    public var _name : String
    public var _cost : Int
    public var _tick : Float
    
    public init(_ newId:Int) {
        _name = "Off"
        _cost = 0
        _tick = 2.0
    }
    
    public override func create() {
        EventDispatcher.subscribe("PowerOn", self)
    }
    
    public override func update(delta: Float) {
        
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch (eventName) {
        case "PowerOn":
            let str: String! = params["power"] as! String
            if (str == "fire") {
                _name = "fire";
            }
            
            if (str == "water") {
                print("Water Power");
                _name = "water";
            }
            
            if (str == "earth") {
                print("Earth Power");
                _name = "earth";
            }
            
            if (str == "Off") {
                print("Power Off");
                _name = "Off";
            }
            var outputString = "\nPower: " + str
            NSLog(outputString)
            break
            
        default:
            break
        }
    }
}
