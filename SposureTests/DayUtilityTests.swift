//
//  DayUtilityTests.swift
//  Sposure
//
//  Created by Kyle McCrohan on 6/6/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import XCTest
@testable import Sposure

class DayUtilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDaysInOrder() {
        print(DayUtility.getWeekdaysinOrder())
    }
    
    func testFormattedDay() {
        print(DayUtility.getFormattedDateFromIndex(0))
    }
    
    func testFormattedDaysInLastWeek() {
        print(DayUtility.getFormattedDatesForLastWeek())
    }
    
}

