//
//  GiphyRequest.swift
//  Sposure
//
//  Created by Evan Conrad on 5/29/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation

class GiphyRequest {
    
    let offset : Int
    let limit  : Int
    
    init(offset : Int, limit : Int ) {
        self.offset = offset
        self.limit  = limit
    }
}