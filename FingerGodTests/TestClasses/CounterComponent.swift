//
//  CounterComponent.swift
//  FingerGodTests
//
//  Created by Aaron F on 2018-02-16.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import FingerGod

class CounterComponent : Component {
    public var count = 0;
    override func update(delta: Float) {
        count += 1;
    }
}
