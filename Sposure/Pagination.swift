//
//  Pagination.swift
//  Sposure
//
//  Created by Evan Conrad on 5/21/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import ObjectMapper

class Pagination : Mappable {
    
    var total_count : Int?
    var count       : Int?
    var offset      : Int?
    
    init(total_count : Int, count : Int, offset : Int) {
        self.total_count = total_count
        self.count       = count
        self.offset      = offset
    }
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        total_count <- map["total_count"]
        count       <- map["count"]
        offset      <- map["offset"]
    }
    
    /**
     * Returns dummy data for testing
     */
    class func dummy() -> Pagination {
        return Pagination(total_count: 1947, count: 25, offset: 0)
    }
}