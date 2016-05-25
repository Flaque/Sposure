//
//  GifReturnObject.swift
//  Sposure
//
//  Created by Evan Conrad on 5/21/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import UIKit

class GifImage {
    
    let image  : UIImage!
    let gif : Gif!
    
    init (image : UIImage!, gif : Gif) {
        print("GifImage Object Created")
        self.image  = image
        self.gif    = gif
    }
    
    deinit {
        print("---------- REMOVED OBJECT")
    }
}

