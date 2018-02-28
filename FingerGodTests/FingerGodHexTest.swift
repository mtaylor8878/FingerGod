//
//  FingerGodHexTest.swift
//  FingerGodTests
//
//  Created by Niko Lauron on 2018-02-21.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import XCTest
@testable import FingerGod

class FingerGodHexTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMapCreate() {
        var count = 0
        let width = 10
        let height = 10
        
        let map = TileMap(width, height, 3)
        
        for _ in map.getTiles() {
            count += 1
        }
        
        XCTAssert(count == 100)
    }
}
