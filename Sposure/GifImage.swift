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
        self.image  = image
        self.gif    = gif
    }
    
    deinit {
        print("---- Deinited GifImage")
    }
    
    /**
     * Gets a dummy GifImage for testing
     */
    class func dummy() -> GifImage {
        let dummy_image : UIImage = UIImage(gifName: "jeremy")
        let dummy_gif   : Gif     = Gif.dummy()
        return GifImage(image: dummy_image, gif: dummy_gif)
    }
}

