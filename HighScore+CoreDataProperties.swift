//
//  HighScore+CoreDataProperties.swift
//  
//
//  Created by Kyle McCrohan on 6/6/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HighScore {

    @NSManaged var score: NSNumber?
    @NSManaged var date: String?
    @NSManaged var category : NSString?

}
