//
//  GifBuffer.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import Async

class GifBuffer {
    
    //Main Internal Queues
    private let _GiphyResponseQueue : Queue<Gif>!      = Queue<Gif>()
    private let _GifImageQueue      : Queue<GifImage>! = Queue<GifImage>()
    
    //Main Async Grand Central Dispatch queues
    private let gcdAsyncGroup = AsyncGroup()
    
    private let MAX_RESPONSE_AMMOUNT = 10
    private let MAX_GIF_IMAGE_QUEUE  = 3
    
    /**
     Boots up the modules
    */
    init() {
        
        _launchGiphyManager()
        _launchGifImageCreator()
    }
    
    /**
     * Launches the giphy manager module
     * to run in the background
     */
    private func _launchGiphyManager() {
        gcdAsyncGroup.background {
            //while (true) {
                self._getGifObjects()
            //}
        }
    }
    
    /**
     * Launches the Gif Image Creator module
     * to run in the background
     */
    private func _launchGifImageCreator() {
        gcdAsyncGroup.background {
            while (true) {
                self._getGifImages()
            }
        }
    }
    
    /**
     The only real public method in GifBuffer. (other than init)
     Pulls from the _GifImageQueue, if there's nothing, returns onEmpty()
     
     - parameter onSuccess : Called when there's something in the queue
     - parameter onEmpty   : Called when there's nothing in the queue
    */
    func pull(onSuccess : (GifImage) -> Void, onEmpty : () -> Void) {
        guard (!_GifImageQueue.isEmpty()) else { onEmpty(); return }
        
        onSuccess(_GifImageQueue.dequeue()!)
    }
    
    /**
     Pushes to the _GifImageQueue.
     
     Q: Why is this a function if it's basically only one line?
     A: So we can cleanly pass it into a NETWORK callback
    */
    private func _pushToGifImageQueue(gifImage : GifImage) {
       self._GifImageQueue.enqueue(gifImage)
    }
    
    /**
     Pushes to the _GiphyResponseQueue.
     
     Q: Why is this a function if it's basically only one line?
     A: So we can cleanly pass it into a NETWORK callback
     */
    private func _pushToGiphyResponseQueue(gif : Gif!) {
        
        //Don't enqueue a nil gif
        guard (gif != nil) else { return }
        self._GiphyResponseQueue.enqueue(gif)
        self._getGifImages()
    }
    
    /**
     Gets more gif objects and populates the _GiphyResponseQueue
    */
    private func _getGifObjects() {
        
        guard (self._GiphyResponseQueue.count() <= self.MAX_RESPONSE_AMMOUNT) else { return}
        
        GiphyManager.search(self._pushToGiphyResponseQueue, onError: GifBuffer.logError)
    }
    
    /**
     Pulls from the _GifResponseQueue, creates the image, and then populates the _GifImageQueue
    */
    private func _getGifImages() {
        
        guard (self._GifImageQueue.count() <= self.MAX_GIF_IMAGE_QUEUE) else { return }
        
        guard !(self._GiphyResponseQueue.isEmpty()) else { return }
        
        let gif : Gif! = self._GiphyResponseQueue.dequeue()
        
        //Can aparently happen? why?
        guard (gif != nil) else {return}
        
        GifImageCreator.findImage(gif, onSuccess: self._pushToGifImageQueue)
    }
    
    /**
     Utility function that logs errors
     msg : String - The error msg
     */
    class func logError(msg : String) {
        print("NETWORK ERROR: " + msg)
    }
    
    
}