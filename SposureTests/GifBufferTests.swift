//
//  GifBufferTests.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import XCTest
@testable import Sposure

class GifBufferTests: XCTestCase {
    
    let network = Network()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGiphyManagerSearch {
        GiphyManager.search({ (gif : Gif) in
            
            
            
            }) { (msg) in
                
        }
    }
    
}
