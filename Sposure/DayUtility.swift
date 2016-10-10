//
//  DayUtility.swift
//  Sposure
//
//  Created by Kyle McCrohan on 6/6/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation

class DayUtility {
    
    static let secondsPerDay = 3600 * 24
    
    static let weekdaySymbols = ["Sun", "Mon","Tues","Wed","Thurs","Fri","Sat"]
    
    /**
     Returns a string array that is the previous seven days (up to and including today) in order.
     */
    static func getWeekdaysinOrder() -> [String] {
        
        // Adjust for time zone.
        let adjustedDate = Date().addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
        // This reference date in 1970 is a Sunday.
        let referenceDate = Date(timeIntervalSince1970: TimeInterval(secondsPerDay * 3))
        
        // Find number of days since reference date, mod 7 will be day of the week. Add one to offset
        let startingIndex = Int(adjustedDate.timeIntervalSince(referenceDate) / (3600 * 24)) % 7 + 1
        var index = startingIndex
        
        var days = [String]()
        // Create an array of days adjusted to start at the current day.
        repeat {
            days.append(weekdaySymbols[index])
            index = (index + 1) % 7
        } while index != startingIndex
        
        return days
    }
    
    /**
     Returns a formatted date from day index (MM/DD/YYYY).
     
     - Parameter dayIndex: day relative today (0 = today, 1 = tomorrow...)
     */
    static func getFormattedDateFromIndex(_ dayIndex : Int) -> String {
        
        // Adjusted date to time zone.
        var adjustedDate = Date().addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
        // Add days for day index.
        adjustedDate = adjustedDate.addingTimeInterval(CFTimeInterval(secondsPerDay * dayIndex))
        return getFormattedDate(adjustedDate)
    }
    
    /**
     Returns a formatted date (MM/DD/YYYY).
     
     - Parameter dayIndex: day relative today (0 = today, 1 = tomorrow...)
     */
    static fileprivate func getFormattedDate(_ date : Date) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.string(from: date)
    }
    
    /** Returns all dates in the last week formatted nicely (MM/DD/YYYY) in string array. */
    static func getFormattedDatesForLastWeek() -> [String] {
        var days = [String]()
        for index in -6...0 {
           days.append(getFormattedDateFromIndex(index))
        }
        return days
    }

}
