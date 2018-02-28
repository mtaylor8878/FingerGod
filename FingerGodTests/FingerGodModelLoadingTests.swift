//
//  FingerGodModelLoadingTests.swift
//  FingerGodTests
//
//  Created by Aaron Freytag on 2018-02-21.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import XCTest
@testable import FingerGod

class FingerGodModelLoadingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testModelLoadBasic() {
        do {
            let model = try ModelReader.read(objPath: "CubeModel")
            XCTAssert(model.vertices[0] == -1.0)
            XCTAssert(model.vertices[1] == -1.0)
            XCTAssert(model.vertices[2] == 1.0)
            XCTAssert(model.vertices[3] == -1.0)
            XCTAssert(model.normals[0] == -0.0)
            XCTAssert(model.normals[1] == -1.0)
            XCTAssert(model.normals[2] == 0.0)
            XCTAssert(model.normals[4] == 1.0)
            XCTAssert(model.faces[0] == 2)
            XCTAssert(model.faces[1] == 4)
            XCTAssert(model.faces[2] == 1)
            XCTAssert(model.faces[3] == 8)
        } catch {
            print("There was a problem: \(error)");
            XCTAssert(false)
        }
    }
    
}
