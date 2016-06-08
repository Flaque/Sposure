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
    
    let managerGCD   : GCDQueue          = .createConcurrent("ImageManagerGCD")
    let imageGCD     : GCDQueue          = .createSerial("imageGCD")
    let imageQueue   : Queue<GifImage>   = Queue<GifImage>()
    let giphyManager : GiphyManager
    
    let MAX_IMAGE_AMMOUNT = 5
    var max_hit : Bool = false
    var running = true
    
    init(giphyManager : GiphyManager) {
        self.giphyManager = giphyManager
        
       
        managerGCD.async() {
            while(self.running) {
                self.giphyManager.urlQueueSemaphore.wait()
                
                if (!self.max_hit) { self.addTask(self.giphyManager) }
            }
        }
    }
    
    func stop() {
        self.running = false
    }
    
    deinit {
        print("Deinited giphyManager")
    }
    
    func addTask(giphyManager : GiphyManager) {
        var gif : Gif?
        
        giphyManager.responseGCD.sync() {
            gif = self.giphyManager.responseQueue.dequeue()
        }
        
        managerGCD.async() {
            guard (gif != nil) else { print("gif nil"); return }
            Imager.findImage(gif, onSuccess : self.onSuccess)
        }
    }
    
    /**
     * Pushes to image queue
     */
    func onSuccess(gifImage : GifImage) -> Void {
        
        imageGCD.sync() {
            self.imageQueue.enqueue(gifImage)
            
            self.checkIfMaxHit()
        }
    }
    
    /**
     * Pull from image manager
     */
    func pull(onSuccess : (GifImage) -> Void, onEmpty : () -> Void) {
        
        imageGCD.sync() {
            guard (!self.imageQueue.isEmpty()) else { onEmpty(); return }
            
            //When we need more gifs, pull some more
            onSuccess(self.imageQueue.dequeue()!)
            
            self.checkIfMaxHit()
        }
    }
    
    /**
     * Check if max_hit, then tell the manager GCD
     */
    func checkIfMaxHit() {
        //Check if max_hit, then tell the manager GCD
        let hit = self.imageQueue.count() >= self.MAX_IMAGE_AMMOUNT
        self.managerGCD.sync() {
            self.max_hit = hit
        }
    }
    
    
}