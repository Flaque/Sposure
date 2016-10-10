//
//  HighScoreManager.swift
//  Sposure
//
//  Created by Kyle McCrohan on 6/6/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class HighScoreManager {
    
    /** Retreive the managedObjectContext from AppDelegate. Used for CoreData */
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    /** Entity identifier. */
    static let entityId = "HighScore"
    
    /** Adds a high score to the persistent storage.
     */
    static func addScore(_ score : Int, category : String) -> Void {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: entityId, into: self.managedObjectContext) as! HighScore
        newItem.score = score as NSNumber?
        newItem.date = DayUtility.getFormattedDateFromIndex(0)  // get today's date in this time zone.
        newItem.category = category as NSString?
        
        saveCoreData()
    }
    
    /** Saves the core data state. */
    fileprivate static func saveCoreData() {
        do {
            try managedObjectContext.save()
        } catch { }
    }
    
    /** Returns an array of total scores for each day in last week. */
    static func getScoresForLastWeek() -> [Int] {
        let days = DayUtility.getFormattedDatesForLastWeek()
        var totals = [Int]()
        for day in days {       // Loop through each day
            var total = 0
            for score in getHighScores() {      // Loop through each score
                if score.date == day {          // If day and score's date match, add it to total
                    total += score.score as! Int
                }
            }
            totals.append(total)
        }
        return totals
    }
    
    /** Returns an all time complete total score. */
    static func getTotalAllTimeScore() -> Int {
        var total = 0
        for score in getHighScores() {
            total += score.score as! Int
        }
        return total
    }
    
    /** Returns a list of high scores. */
    fileprivate static func getHighScores() -> [HighScore] {

        let fetchRequest = NSFetchRequest(entityName: entityId)
        do {
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [HighScore] {
                if fetchResults.count > 0 { // Check to make sure there actually are results or it'll throw an error
                    return fetchResults
                }
            }
        } catch { }
        return []
    }
}
