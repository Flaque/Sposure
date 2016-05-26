//
//  GiphyManagerTest.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation

import XCTest
@testable import Sposure

class GiphyManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print(" ------------------------------------- ")
        super.tearDown()
    }
    
    /**
     Tests wether or not search GiphyManager.search() returns something
    */
    func test_search_returns_something() {
        print("Test : search_returns_something")
        
        let expectation = expectationWithDescription("Search completes")
        
        GiphyManager.search({ (gif : Gif) in
            
            //Assert that the gif has info
            XCTAssertNotNil(gif.getURL())
            XCTAssertNotNil(gif.getFrames())
            
            print("------")
            print(gif.toJSONString())
            print("------")
            
            //Search completed
            expectation.fulfill()
            
        }) { (msg :String ) in
            
            //If we get here, fail
            XCTFail()
        }
        
        
        waitForExpectationsWithTimeout(10) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
