//
//  SearchSubject+CoreDataProperties.swift
//  
//
//  Created by Kyle McCrohan on 6/10/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SearchSubject {

    @NSManaged var subject: String?
    @NSManaged var date: Date?
    @NSManaged var frequency: NSNumber?

}
