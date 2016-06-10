//
//  SearchSubjectsManager.swift
//  Sposure
//
//  Created by Kyle McCrohan on 6/9/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SearchSubjectsManager {
    
    /** Retreive the managedObjectContext from AppDelegate. Used for CoreData */
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    /** Entity identifier. */
    static let entityId = "SearchSubject"
    
    /** Adds a high score to the persistent storage.
     */
    static func addSearch(subject : String) -> Void {
        
        // Try incrementing the search if it exists.
        if !incrementSearchWithSubject(subject) {
            
            // If unsuccessful increment, then add new entry.
            let newItem = NSEntityDescription.insertNewObjectForEntityForName(entityId, inManagedObjectContext: self.managedObjectContext) as! SearchSubject
            newItem.date = NSDate()
            newItem.subject = subject
            newItem.frequency = 1
        }
        saveCoreData()

    }
    
    /** Saves the core data state. */
    private static func saveCoreData() {
        do {
            try managedObjectContext.save()
        } catch { }
    }
    
    /**
     Increments the frequency of this search by one, if the search previously exists.
     
     - Parameter subject : the string that was searched.
     
     - Returns : true if found and incremented, false if no previous entry.
    */
    private static func incrementSearchWithSubject(subject : String) -> Bool {
        
        // Predicate that we are looking for a specific entry
        let fetchRequest = NSFetchRequest(entityName: entityId)
        fetchRequest.predicate = NSPredicate(format: "subject = %@", subject)
        
        do {
            if let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0 {
    
                    // Add one to the frequency of this entry.
                    let managedObject = fetchResults[0]
                    let frequency = managedObject.valueForKey("frequency") as! Int
                    managedObject.setValue(frequency+1, forKey: "frequency")
                    managedObject.setValue(NSDate(), forKey: "date")    // set the current date.
    
                    return true
                }
            }
        } catch { }
        return false

    }
    
    /** Sorts the searches by frequency */
    static func orderSearches(inout results : [SearchSubject]) {
        results.sortInPlace({ $0.frequency as! Int > $1.frequency as! Int })
    }
    
    /** Returns a list of search subjects, ordered by frequency and recency. */
    static func getSortedSearchSubjects() -> [String] {
        var subjects = [String]()
        
        var results = getSearchSubjects()
        orderSearches(&results)      // order the results
        
        for r in results {
            subjects.append(r.subject!)  // take only the subject and add to string array
        }
        
        return subjects
    }
    
    /** Returns a list of search subjects. */
    private static func getSearchSubjects() -> [SearchSubject] {
        
        let fetchRequest = NSFetchRequest(entityName: entityId)
        do {
            if let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [SearchSubject] {
                if fetchResults.count > 0 { // Check to make sure there actually are results or it'll throw an error
                    return fetchResults
                }
            }
        } catch { }
        return []
    }

}