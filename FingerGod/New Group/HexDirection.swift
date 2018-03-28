//
//  HexDirection.swift
//  FingerGod
//
//  Created by Matthew Taylor on 2018-03-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

/// HexDirection
/// =========
/// Enumeration for list of directions from a flat-top hex tile
///
public enum HexDirection: Int {
    case North
    case NorthEast
    case SouthEast
    case South
    case SouthWest
    case NorthWest
}

public class HexDirections {
    public static let Count = 6
    
    public static func RandomDirection() -> HexDirection {
        return HexDirection(rawValue: Int(arc4random_uniform(UInt32(Count))))!
    }
    
    private static let vectors: [Point2D] = [
        Point2D(0, -1),
        Point2D(1, -1),
        Point2D(1, 0),
        Point2D(0, 1),
        Point2D(-1, 1),
        Point2D(-1, 0)
    ]
        
    public static func AsVector(_ direction: HexDirection) -> Point2D {
        return vectors[direction.rawValue]
    }
    
    public static func InDirection(_ point:Point2D, _ direction: HexDirection) -> Point2D {
        return point + AsVector(direction)
    }
    
    public static func InDirection(_ point:Point2D, _ direction: HexDirection, _ distance: Int) -> Point2D {
        return point + AsVector(direction) * distance
    }
    
    public static func NextDirection(_ direction: HexDirection) -> HexDirection {
        var next = direction.rawValue + 1
        if next == Count {
            next = 0
        }
        return HexDirection(rawValue: next)!
    }
}

