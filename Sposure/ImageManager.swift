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
    
    /// Manages the imageQueueSize
    let countGCD     : GCDQueue          = .createSerial("countGCD")
    
    /// Launches addTask()'s
    let managerGCD   : GCDQueue          = .createConcurrent("ImageManagerGCD")
    
    /// Manages Enqueue and equeue of image queue
    let imageGCD     : GCDQueue          = .createSerial("imageGCD")
    
    /// Stores the Gif Images
    let imageQueue   : Queue<GifImage>   = Queue<GifImage>()
    
    
    let giphyManager : GiphyManager
    let MAX_IMAGE_AMMOUNT = 2
    var imageQueueSize : Int = 0
    var queuedTasks : Int = 0
    var running = true
    
    init(giphyManager : GiphyManager) {
        self.giphyManager = giphyManager
        
       
        managerGCD.async() {
            while(self.running) {
                self.giphyManager.urlQueueSemaphore.wait()
                
                // Check if we're already full with tasks
                var stop = false
                self.countGCD.sync() { stop = self.canAddAnotherTask() }
                guard (!stop) else { continue }
                
                //Add a task
                self.incrementTaskCount()
                self.addTask(self.giphyManager)
            }
        }
    }
    
    func canAddAnotherTask() -> Bool {
        return !((self.queuedTasks + self.imageQueueSize) <= self.MAX_IMAGE_AMMOUNT)
    }
    
    /**
     Increments the queuedTasks by 1 inside of a countGCD.
     */
    func incrementTaskCount() {
        self.countGCD.sync() {
            self.queuedTasks += 1
        }
    }
    
    /**
     Stops the system
     */
    func stop() {
        managerGCD.sync() {
            self.running = false
        }
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
            guard (self.running) else { print("quitting."); return }
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
        managerGCD.sync() {
            self.queuedTasks -= 1
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
        let count = self.imageQueue.count()
        self.managerGCD.sync() {
            self.imageQueueSize = count
        }
    }
    
    
}