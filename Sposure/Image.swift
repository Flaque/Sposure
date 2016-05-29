//
//  Image.swift
//  Sposure
//
//  Created by Evan Conrad on 5/21/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import ObjectMapper

class Image : Mappable {
    
    var url : String?
    var frames : String?
    
    init( url : String, frames : String) {
        self.url    = url
        self.frames = frames
    }
    
    required init? (_ map: Map){}
    
    func mapping(map: Map) {
        frames  <- map["frames"]
        url     <- map["url"]
    }
    
    class func dummy() -> Image {
        return Image(url: "http://media2.giphy.com/media/FiGiRei2ICzzG/giphy.gif", frames: "22")
    }
}