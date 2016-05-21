//
//  Images.swift
//  Sposure
//
//  Created by Evan Conrad on 5/21/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import ObjectMapper

class Images : Mappable {
    
    var original : Image?
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        original <- map["original"]
    }
}