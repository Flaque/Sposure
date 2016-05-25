//
//  GifBuffer.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation

class GifBuffer {
    
    //Main Internal Queues
    private let _GiphyResponseQueue : Queue<Gif>      = Queue<Gif>()
    private let _GifImageQueue      : Queue<GifImage> = Queue<GifImage>()
    
    private let MAX_RESPONSE_AMMOUNT = 10
    private let MAX_GIF_IMAGE_QUEUE  = 3
    
    /**
     Boots up the modules
    */
    init() {
        print("Started Gif Buffer")
        launchOneGiphyManager()
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
        print("- Made an image! ")
        _GifImageQueue.enqueue(gifImage)
    }
    
    /**
     Pushes to the _GiphyResponseQueue.
     
     Q: Why is this a function if it's basically only one line?
     A: So we can cleanly pass it into a NETWORK callback
     */
    private func _pushToGiphyResponseQueue(gif : Gif) {
        print("+ Got a response! ")
        _GiphyResponseQueue.enqueue(gif)
        self._getGifImages()
    }
    
    /**
     Gets more gif objects and populates the _GiphyResponseQueue
    */
    private func _getGifObjects() {
        print("Trying to find a gif Object")
        
        guard (_GiphyResponseQueue.count() <= MAX_RESPONSE_AMMOUNT) else {
            print("Is max ammount")
            return
        }
        
        GiphyManager.search(_pushToGiphyResponseQueue, onError: GifBuffer.logError)
    }
    
    /**
     Pulls from the _GifResponseQueue, creates the image, and then populates the _GifImageQueue
    */
    private func _getGifImages() {
        
        guard (_GifImageQueue.count() <= MAX_GIF_IMAGE_QUEUE) else {
            print("Is max ammount")
            return
        }
        
        guard !(_GiphyResponseQueue.isEmpty()) else {
            print("Is Empty")
            return
        }
        
        let gif : Gif! = _GiphyResponseQueue.dequeue()
        GifImageCreator.findImage(gif, onSuccess: _pushToGifImageQueue)
    }
    
    /**
     Launches a giphy Manager loop thread
    */
    private func launchOneGiphyManager() {
        self._getGifObjects()
    }
    
    /**
     Utility function that logs errors
     msg : String - The error msg
     */
    class func logError(msg : String) {
        print("NETWORK ERROR: " + msg)
    }
    
    
}