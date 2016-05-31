//
//  GifBufferTest.swift
//  Sposure
//
//  Created by Evan Conrad on 5/28/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import XCTest
@testable import Sposure

class GifBufferTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("------------------------------------- ")
        super.tearDown()
    }
    
    func wait_for_pull(gifBuffer : GifBuffer) {
        
        let expectation = expectationWithDescription("loads and image")
        
        gifBuffer.pull({ (gifImage : GifImage) in //Success block
            XCTAssertNotNil(gifImage)
            XCTAssertNotNil(gifImage.gif)
            XCTAssertNotNil(gifImage.image)
            
            expectation.fulfill()
        }) { //Erorr Block
            XCTFail()
        }
        
        //Wait 10 seconds to get image
        waitForExpectationsWithTimeout(10) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func test_pull() {
        let gifBuffer : GifBuffer = GifBuffer()
        
        gifBuffer._pushToGifImageQueue(GifImage.dummy())
        
        sleep(2)
        
        wait_for_pull(gifBuffer)
    }
    
    func test_loads() {
        
        let gifBuffer : GifBuffer = GifBuffer()
        wait_for_pull(gifBuffer)
    }
}