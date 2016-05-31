//
//  ImageManager.swift
//  Sposure
//
//  Created by Evan Conrad on 5/30/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import GCDKit

class ImageManager {
    
    let imageGCD     : GCDKit           = .createSerial("imageQueue")
    let imageQueue   : Queue<GifImage>  = Queue<GifImage>()
    let giphyManager : GiphyManager
    
    init(giphyManager : GiphyManager) {
        self.giphyManager = giphyManager
    }
    
    func addTask() {
        //var stop = false
        var gif : Gif?
        
        GiphyManager.responseGCD.sync() {
            //guard (!giphyManager.responseQueue.isEmpty()) else { stop = true; return }
            gif = giphyManager.responseQueue.dequeue()
        }
        
        imageGCD.async() {
            guard (!giphyManager.responseQueue.isEmpty()) else { return }
            Imager.findImage(gif, onSuccess : onSuccess)
        }
    }
    
    func onSuccess(gifImage : GifImage) -> Void {
        print("Got an image")
    }
    
}