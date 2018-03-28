//
//  Structure.swift
//  FingerGod
//
//  Created by Matthew Taylor on 2018-03-28.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation

public class Structure {
    public var model : ModelInstance
    public let tile : Tile
    
    public init(_ tile: Tile, _ mi: ModelInstance) {
        self.tile = tile
        self.model = mi
    }
    
    public func onSelect() {}
}
