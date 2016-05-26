//
//  GifImageCreator.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation

import XCTest
@testable import Sposure

class GifImageCreatorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("------------------------------------- ")
        super.tearDown()
    }
    
    func test_findImage() {
        
        //Create Mock data
        let image  : Image  = Image(url: "https://media4.giphy.com/media/OmK8lulOMQ9XO/giphy.gif", frames: "63")
        let images : Images = Images(original: image)
        let gif    : Gif    = Gif(id: "OmK8lulOMQ9XO", images: images, rating: "pg")
        
        print(gif.getURL())
        
        let expectation = expectationWithDescription("findImage completes")
        
        GifImageCreator.findImage(gif, onSuccess: { (gifImage : GifImage) in
            
            XCTAssertNotNil(gifImage.gif)
            XCTAssertNotNil(gifImage.image)
            
            //Fulfill expectation
            expectation.fulfill()
            
        }) { (msg : String) in
            print(" -------- ")
            print(msg)
            print(" -------- ")
            
            XCTFail()
        }
        
        //Wait 10 seconds to get image
        waitForExpectationsWithTimeout(10) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}