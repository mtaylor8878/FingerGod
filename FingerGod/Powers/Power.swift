//
//  Power.swift
//  FingerGod
//
//  Created by Niko Lauron on 2018-03-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class Power : Component, Subscriber {
    
    open override func create() {
        EventDispatcher.subscribe("PowerOn",self)
    }
    
    func notify(_ eventName: String, _ params: [String : Any]) {
        switch (eventName) {
        case "PowerOn":
            let str: String! = params["power"] as! String
            if (str == "fire") {
                print("Fire Power");
                
            }
            
            if (str == "water") {
                print("Water Power");
                
            }
            
            if (str == "lightning") {
                print("Lightning Power");
                
            }
            
            if (str == "earth") {
                print("Earth Power");
                
            }
            
            if (str == "Off") {
                print("Power Off");
                
            }
            break
            
        default:
            break
        }
    }
}
