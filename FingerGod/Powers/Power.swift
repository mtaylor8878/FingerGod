//
//  Power.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-03-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

class Power : Component, Subscriber {
    
    var power : String = "none"

    open override func create() {
        EventDispatcher.subscribe("PowerOn",self)
    }
    
    open override func update(delta: Float) {
        if (power == "fire") {
            
        }
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch (eventName) {
        case "PowerOn":
            let str: String! = params["power"] as! String
            if (str == "fire") {
                print("Fire Power");
                power = "fire";
            }
            
            if (str == "water") {
                print("Water Power");
                power = "water";
            }
            
            if (str == "lightning") {
                print("Lightning Power");
                power = "water";
            }
            
            if (str == "earth") {
                print("Earth Power");
                power = "earth";
            }
            
            if (str == "Off") {
                print("Power Off");
                power = "none";
            }
            break
            
        default:
            break
        }
    }
}
