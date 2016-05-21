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
    
    private var id      : [String]?
    private var images  : Images?
    private var rating  : String? //g, pg, pg-13, r
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        id     <- map["id"]
        images <- map["images"]
        rating <- map["rating"]
    }
    
    func getFrames() -> Int {
        return Int((self.images?.original?.frames)!)!
    }
    
    func getURL() -> String {
        return self.images!.original!.url!
    }
}

