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
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    /** Entity identifier. */
    static let entityId = "SearchSubject"
    
    static let defaultSearches = ["Cats","Clowns","Vomit","Spiders","Speaking","Water","Airplanes"]
    
    /** Adds a high score to the persistent storage.
     */
    static func addSearch(_ subject : String) -> Void {
        
        // Try incrementing the search if it exists.
        if !incrementSearchWithSubject(subject) {
            
            // If unsuccessful increment, then add new entry.
            let newItem = NSEntityDescription.insertNewObject(forEntityName: entityId, into: self.managedObjectContext) as! SearchSubject
            newItem.date = Date()
            newItem.subject = subject
            newItem.frequency = 1
        }
        saveCoreData()

    }
    
    /** Saves the core data state. */
    fileprivate static func saveCoreData() {
        do {
            try managedObjectContext.save()
        } catch { }
    }
    
    /**
     Increments the frequency of this search by one, if the search previously exists.
     
     - Parameter subject : the string that was searched.
     
     - Returns : true if found and incremented, false if no previous entry.
    */
    fileprivate static func incrementSearchWithSubject(_ subject : String) -> Bool {
        
        // Predicate that we are looking for a specific entry
        let fetchRequest = NSFetchRequest(entityName: entityId)
        fetchRequest.predicate = NSPredicate(format: "subject = %@", subject)
        
        do {
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0 {
    
                    // Add one to the frequency of this entry.
                    let managedObject = fetchResults[0]
                    let frequency = managedObject.value(forKey: "frequency") as! Int
                    managedObject.setValue(frequency+1, forKey: "frequency")
                    managedObject.setValue(Date(), forKey: "date")    // set the current date.
    
                    return true
                }
            }
        } catch { }
        return false

    }
    
    /** Sorts the searches by frequency */
    static func orderSearches(_ results : inout [SearchSubject]) {
        results.sort(by: { $0.frequency as! Int > $1.frequency as! Int })
    }
    
    /** Returns a list of search subjects, ordered by frequency and recency. */
    static func getSortedSearchSubjects(_ defaults : Bool = true) -> [String] {
        var subjects = [String]()
        
        var results = getSearchSubjects()
        orderSearches(&results)      // order the results
        
        for r in results {
            subjects.append(r.subject!)  // take only the subject and add to string array
        }
        
        // If we also want defaults, append them.
        if defaults {
            for sub in defaultSearches {
                if subjects.contains(sub) { continue }  // don't add duplicates
                subjects.append(sub)
            }
        }
        
        return subjects
    }
    
    /** Returns a list of search subjects. */
    fileprivate static func getSearchSubjects() -> [SearchSubject] {
        
        let fetchRequest = NSFetchRequest(entityName: entityId)
        do {
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [SearchSubject] {
                if fetchResults.count > 0 { // Check to make sure there actually are results or it'll throw an error
                    return fetchResults
                }
            }
        } catch { }
        return []
    }

}
