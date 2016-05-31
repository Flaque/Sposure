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
        //Queue at this point: [1]
        
        //Assert not just one enqueue and dequeue screws things up
        queue.dequeue()
        XCTAssert(queue.isEmpty())
        //Queue at this point :[]
        
        //Add something else, so now we have a front and back
        queue.enqueue(1)
        queue.enqueue(2)
        XCTAssert(!queue.isEmpty())
        //Queue at this point: [1, 2]
        
        //Add another so now we have front back and middle
        queue.enqueue(3)
        XCTAssert(!queue.isEmpty())
        //Queue at this point: [1, 2, 3]
        
        //Remove something (So now we have two)
        queue.dequeue()
        XCTAssert(!queue.isEmpty())
        //Queue at this point: [2, 3]
        
        //Remove another so now we just have a front
        queue.dequeue()
        XCTAssert(!queue.isEmpty())
        //Queue at this point: [3]
        
        //Show that adding something back is still good
        queue.enqueue(1)
        XCTAssert(!queue.isEmpty())
        //Queue at this point: [3, 1]
        
        //Now we should be empty
        queue.dequeue()
        queue.dequeue()
        XCTAssert(queue.isEmpty())
        //Queue at this point: []
        
        //Now, let's dequeue once more and make sure we're still "empty"
        queue.dequeue()
        XCTAssert(queue.isEmpty())
    }
    
    func test_count() {
        let queue : Queue<Int> = Queue<Int>()
        
        XCTAssert(queue.count() == 0)
        
        //Test if dequeing removes count lower than 0
        queue.dequeue()
        XCTAssert(queue.count() == 0) //Should still be 0
        
        //Make queue [1, 2, 3, 4, 5]
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        queue.enqueue(4)
        queue.enqueue(5)
        XCTAssert(queue.count() == 5)
        
        //Make queue [3, 4, 5]
        queue.dequeue()
        queue.dequeue()
        XCTAssert(queue.count() == 3)
    }
}