//
//  Meta.swift
//  Sposure
//
//  Created by Evan Conrad on 5/21/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import ObjectMapper

class Meta : Mappable {
    
    var status : Int?
    var msg    : String?
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        status <- map["status"]
        msg    <- map["msg"]
    }
}