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
    data: [gif : {
        images : [Image]
    }],
    meta: meta
    pagination: pagination
 }
**/

class SearchResponse : Mappable {
    
    var gifs       : [Gif]?
    var meta       : Meta?
    var pagination : Pagination?
    
    init(gifs : [Gif], meta : Meta, pagination : Pagination) {
        self.gifs       = gifs
        self.meta       = meta
        self.pagination = pagination
    }
    
    required init? (_ map: Map){}
    
    func mapping(_ map: Map) {
        gifs       <- map["data"]
        meta       <- map["meta"]
        pagination <- map["pagination"]
    }
    
    /**
     * Returns dummy data for testing
     */
    class func dummy() -> SearchResponse {
        return SearchResponse(gifs: [Gif.dummy()], meta: Meta.dummy(), pagination: Pagination.dummy())
    }
}
