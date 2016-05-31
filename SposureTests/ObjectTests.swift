//
//  ObjectTests.swift
//  Sposure
//
//  Created by Evan Conrad on 5/29/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import XCTest
@testable import Sposure

class ObjectTests : XCTestCase{
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("------------------------------------- ")
        super.tearDown()
    }
    
    func test_GifImage() {
        let gifImage : GifImage? = GifImage.dummy()
        
        XCTAssertNotNil(gifImage?.image)
        XCTAssertNotNil(gifImage?.gif)
    }
}