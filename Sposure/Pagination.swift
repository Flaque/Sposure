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
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        total_count <- map["total_count"]
        count       <- map["count"]
        offset      <- map["offset"]
    }
}