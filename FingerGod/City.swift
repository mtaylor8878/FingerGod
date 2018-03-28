//
//  City.Swift
//  FingerGod
//
//  Created by Matthew Taylor on 2018-03-28.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import Foundation
import GLKit

public class City: Structure {
    private let owner : PlayerObject
    
    public init(_ pos: Point2D, _ owner: PlayerObject) {
        var castle : Model?
        
        do {
            castle = try ModelReader.read(objPath: "Castle")
        } catch {
            print("There was a problem initializing this tile model: \(error)")
        }
        
        let mi = ModelInstance(model: castle!)
        mi.color = [0.63, 0.63, 0.63, 1.0]
        Renderer.addInstance(inst: mi)
        
        self.owner = owner
        
        super.init(pos, mi)
    }
}
