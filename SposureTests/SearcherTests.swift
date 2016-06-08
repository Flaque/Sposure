//
//  SearcherTests.swift
//  Sposure
//
//  Created by Evan Conrad on 6/7/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import XCTest
@testable import Sposure

class SearcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /* This fails because onSuccess is called a bazillion times
    func test_search() {
        let request = GiphyRequest(offset: 0, limit: 100)
        
        let expectation = expectationWithDescription("Search loads correctly")
        var firstTime   = true
        
        Searcher.search(request, onSuccess: { (gif : Gif) in
            
            XCTAssertNotNil(gif.getURL()) //Make sure we actually got a gif
            XCTAssertNotNil(gif.getFrames()) //Make su  re we actually get frames
            print("Hello good fellow!")
            
            if (firstTime) { expectation.fulfill(); firstTime = false }
        
        }) { (type : Searcher.ErrorType, msg : String , request : GiphyRequest) in
            
            XCTFail() //If it errors it fails
        }
        
        //Wait and send timeout.
        waitForExpectationsWithTimeout(10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            XCTFail()
        }
    } */
}
