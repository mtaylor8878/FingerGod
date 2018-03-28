//
//  SingleUnit.swift
//  FingerGod
//
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import UIKit

//unit three style，people,follower,demigod
enum Character {
    case PEOPLE
    case FOLLOWER
    case DEMIGOD
}

class SingleUnit: NSObject {
    
    var HP: NSInteger! //hp
    var character: Character?
}

