//
//  PathFindingTarget.swift
//  FingerGod
//
//  Created by Aaron F on 2018-04-16.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public protocol PathFindingTarget {
    // Finds the path step-by-step to the target
    func getPathToTarget(from: Point2D) -> [Point2D]
    
    // Did we do what we were supposed to do?
    func fulfilled(by: UnitGroupComponent) -> Bool
}
