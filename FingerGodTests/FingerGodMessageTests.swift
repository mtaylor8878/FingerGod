//
//  FingerGodModelLoadingTests.swift
//  FingerGodTests
//
//  Created by Matt Taylor on 2018-02-27.
//  Copyright © 2018 Ramen Interactive. All rights reserved.
//

import XCTest
@testable import FingerGod

class FingerGodMessageTests: XCTestCase {
    private var testSub = TestSubscriber()
    
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
    
    func testSubscribeEvent() {
        XCTAssert(EventDispatcher.subscribe("TestEvent", testSub))
    }
    
    func testUnsubscribeEvent() {
        EventDispatcher.subscribe("TestEvent", testSub)
        XCTAssert(EventDispatcher.unsubscribe("TestEvent", testSub))
    }
    
    func testPublishEvent() {
        EventDispatcher.subscribe("TestEvent", testSub)
        var paramList = [String : Any]()
        paramList["TestParam1"] = "This is parameter 1"
        paramList["TestParam2"] = "This is parameter 2"
        let expected = FingerGodMessageTests.printParamList("TestEvent", paramList)
        EventDispatcher.publish("TestEvent", paramList)
        NSLog(testSub.lastMessage)
        XCTAssert(testSub.lastMessage == expected)
    }
    
    class TestSubscriber : Subscriber {
        public var lastMessage : String
        
        init(){
            lastMessage = ""
        }
        
        func notify(_ eventName: String, _ params: [String : Any]) {
            lastMessage = FingerGodMessageTests.printParamList(eventName, params)
        }
    }
    
    static func printParamList(_ eventName: String, _ params: [String : Any]) -> String {
        var out = "Name: " + eventName + "\nParamList:\n"
        for (key, value) in params {
            out += "\t" + key + ": " + String(describing: value) + "\n"
        }
        return out
    }

}

