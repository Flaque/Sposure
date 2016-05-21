//
//  The Root level JSON mapper
//
//  SearchRequest.swift
//  Sposure
//
//  Created by Evan Conrad on 5/21/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Layout of JSON response: 
 
 {
    data: [gifs],
    meta: meta
    pagination: pagination
 }
**/

class SearchResponse : Mappable {
    
    public var gifs       : [Gif]?
    public var meta       : Meta?
    public var pagination : Pagination?
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        gifs       <- map["data"]
        meta       <- map["meta"]
        pagination <- map["pagination"]
    }
}
