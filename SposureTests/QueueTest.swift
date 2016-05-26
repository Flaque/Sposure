//
//  QueueTest.swift
//  Sposure
//
//  Created by Evan Conrad on 5/25/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation

import XCTest
@testable import Sposure

class QueueTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("------------------------------------- ")
        super.tearDown()
    }
    
    func test_enqueue() {
        let queue : Queue<Int> = Queue<Int>()

        //Add something, prove that all works
        queue.enqueue(3752)
        XCTAssert(queue.count()   == 1)
        XCTAssert(queue.dequeue() == 3752)
        
        
        //Queue should be [42, 43]
        queue.enqueue(42)
        queue.enqueue(43)
        XCTAssert(queue.count()   == 2)
        XCTAssert(queue.dequeue() == 42)
        XCTAssert(queue.dequeue() == 43)
        XCTAssert(queue.dequeue() == nil)
        
        queue.enqueue(1)
        XCTAssert(queue.dequeue() == 1)
    }
    
    func test_empty() {
        let queue : Queue<Int> = Queue<Int>()
        XCTAssert(queue.isEmpty())
        
        //Add something
        queue.enqueue(1)
        XCTAssert(!queue.isEmpty())
        
        //Add something else, so now we have a front and back
        queue.enqueue(2)
        XCTAssert(!queue.isEmpty())
        
        //Add another so now we have front back and middle
        queue.enqueue(3)
        XCTAssert(!queue.isEmpty())
        
        //Remove something (So now we have two)
        queue.dequeue()
        XCTAssert(!queue.isEmpty())
        
        //Remove another so now we just have a front
        queue.dequeue()
        XCTAssert(!queue.isEmpty())
        
        //Show that adding something back is still good
        queue.enqueue(1)
        XCTAssert(!queue.isEmpty())
        
        //Now we should be empty
        queue.dequeue()
        queue.dequeue()
        XCTAssert(queue.isEmpty())
    }
    
    func test_count() {
        let queue : Queue<Int> = Queue<Int>()
        
        XCTAssert(queue.count() == 0)
        
        //Test if dequeing removes count lower than 0
        queue.dequeue()
        XCTAssert(queue.count() == 0) //Should still be 0
    }
}