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
    
    init(status : Int, msg : String) {
        self.status = status
        self.msg    = msg
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg    <- map["msg"]
    }
    
    class func dummy() -> Meta {
        return Meta(status: 200, msg: "OK")
    }
}