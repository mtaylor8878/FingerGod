//
//  UnitModel.swift
//  FingerGod
//
//  Created by Jade Zhang on 2018-02-23.
//  Copyright © 2018年 Ramen Interactive. All rights reserved.
//

import Foundation

public class UnitModel: NSObject {
    var unitID :String?
    //var _unitFollowsArray :NSMutableArray?
    //number of follower && It can be changed
    var followerNum :NSInteger? = 6
    

    //to manage the amount of followers
    func addFollower() {
        followerNum = followerNum! + 1
    }
    func removeFollower() {
        followerNum = followerNum! - 1
    }
}

