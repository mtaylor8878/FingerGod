//
//  SingleUnit.swift
//  FingerGod
//
//  Created by Jade Zhang on 2018-03-03.
//  Copyright © 2018年 Ramen Interactive. All rights reserved.
//

import Foundation

//unit style：people,follower,demigod
enum Character {
    case PEOPLE
    case FOLLOWER
    case DEMIGOD
}

class SingleUnit: NSObject {

    var HP: NSInteger! //hp
    var character: Character? //The style of this unit
}
