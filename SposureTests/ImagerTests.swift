//
//  Imager.swift
//  Sposure
//
//  Created by Evan Conrad on 6/7/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import XCTest

@testable import Sposure

class ImagerTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    func test_findImage() {
        let gif = Gif.dummy()
        let expectation = expectationWithDescription("Find Image Loads")
        
        Imager.findImage(gif, onSuccess: { (gifImage : GifImage) in
            
            XCTAssertNotNil(gifImage.image)
            XCTAssertNotNil(gifImage.gif)
            
            expectation.fulfill()
            
        }) { (msg : String) in
            print("ERROR: \(msg)")
            XCTFail()
        }
        
        waitForExpectationsWithTimeout(10) { error in
            print("  \n hi \n")
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            //XCTFail()
        }
    } */
}