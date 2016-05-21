//
//  Gif.swift
//  Sposure
//
//  Created by Evan Conrad on 5/21/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import ObjectMapper

class Gif : Mappable {
    
    var id : [String]?
    var url: String?
    var rating : String? //g, pg, pg-13, r
    var frames : Int?
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        id     <- map["id"]
        url    <- map["url"]
        rating <- map["rating"]
    }
}

