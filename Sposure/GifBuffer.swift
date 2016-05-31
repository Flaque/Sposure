//
//  GifBuffer.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import GCDKit

class GifBuffer {
    
    //Main Internal Queues
    internal let _responseQueue : Queue<Gif>!      = Queue<Gif>()
    internal let _imageQueue    : Queue<GifImage>! = Queue<GifImage>()
    
    //Main Async Grand Central Dispatch queues
    internal let responseResourceQueueGCD : GCDQueue = .createSerial("ResponseResourceQueueGCD")
    internal let imageResourceQueueGCD    : GCDQueue = .createSerial("ImageResourceQueueGCD")
    
    internal let responseModuleQueueGCD   : GCDQueue = .createSerial("ResponseModuleQueueGCD")
    internal let imageModuleQueueGCD      : GCDQueue = .createSerial("ImageModuleQueueGCD")
    
    
    
    //Create our own giphy manager (that stores an offset)
    internal let giphyManager : GiphyManager! = GiphyManager()
    
    //Maxes
    internal let MAX_RESPONSE_AMMOUNT = 10
    internal let MAX_GIF_IMAGE_QUEUE  = 3
    
    /**
     Boots up the modules
    */
    init() {
        //_launchGiphyManager()
        //_launchGifImageCreator()
    }
    
    /**
     * Launches the giphy manager module
     * to run in the background
     */
    internal func _launchGiphyManager() {
        for i in 0...10 {
            _addGiphyManagerWork()
        }
    }
    
    /**
     * Launches the Gif Image Creator module
     * to run in the background
     */
    internal func _launchGifImageCreator() {
        
    }
    
    /**
     * Adds a gif image work process.
     */
    internal func _addGifImageWork() {
        
        var gif : Gif?
        
        //Ask the giphyResponse queue if we're good
        self.responseModuleQueueGCD.sync() {
            print("Talked to responseQueue")
            
            //If we're already empty, don't continue on.
            guard !(self._responseQueue.isEmpty()) else { return }
            
        //Ask the image response queue if we're good
        }.notify(self.imageResourceQueueGCD) {
            print("Talked to imageQueue")
            
            //Guard against max images already filled
            guard (self._imageQueue.count() <= self.MAX_GIF_IMAGE_QUEUE) else { return }
            
            //Deque and grab a URL
            gif = self._responseQueue.dequeue()
            
        //Now back to the module queue
        }.notify(self.imageModuleQueueGCD) {
            
            print("Switched back to image Module Queue")
            
            //Finally send the gif off in the image module queue
            self._getGifImages(gif)
        }
    }
    
    /**
     * Adds a giphy manager to a synchronous work queue
     *
     */
    internal func _addGiphyManagerWork() {
        self.responseModuleQueueGCD.sync() {
            self._getGifObjects()
        }
    }
    
    func pull(onSuccess : (GifImage) -> Void, onEmpty : () -> Void) {
        
    }
    
    /**
     The only real public method in GifBuffer. (other than init)
     Pulls from the _GifImageQueue, if there's nothing, returns onEmpty()
     
     - parameter onSuccess : Called when there's something in the queue
     - parameter onEmpty   : Called when there's nothing in the queue
    *
    func pull(onSuccess : (GifImage) -> Void, onEmpty : () -> Void) {
        
        ///Needs to be passed from GDCQueue to MainUI Queue for the onEmpty() UI functionality
        var isEmpty  : Bool?
        var gifImage : GifImage?
        var count    : Int?
        
        self.imageResourceQueueGCD.sync() {
            print("Started pull")
            isEmpty  = self._imageQueue.isEmpty()
            count    = self._imageQueue.count()
            gifImage = self._imageQueue.dequeue()
            
        }.notify(.Main) {
            
            print("Notifying main thread")
            
            //Make sure we're not dealing with a nil isEmpty
            guard (isEmpty != nil) else {
                print ("---- ERROR: isEmpty is nil in pull"); //Alert programmer
                onEmpty(); //Don't load anything
                return //Don't continue.
            }
            
            print("\n GOT HERE1")
            debugPrint(gifImage?.gif.getURL())
            debugPrint(isEmpty)
            debugPrint(count)
            print("\n")
            
            
            //We're going to be super explicit about what's happening here.
            //This is testing if the boolean is true, not "!nil".
            guard(isEmpty == true) else { onEmpty(); return }
            
            print("\n GOT HERE2 \n")
            
            //Make sure we're not dealing with any weird problems from previous 
            //queue's work.
            guard(gifImage != nil) else {
                print("---- ERROR: gifImage is nil in pull")
                onEmpty()
                return
            }
            
            print("\n GOT HERE3 \n")
            
            //All is good, let's show success.
            onSuccess(gifImage!)
        }
    } */
    
    /**
     Pushes to the _GifImageQueue.
     
     Q: Why is this a function if it's basically only one line?
     A: So we can cleanly pass it into a NETWORK callback
    */
    internal func _pushToGifImageQueue(gifImage : GifImage) {
        self.imageResourceQueueGCD.sync() {
            print("Pushed to gifImageQueue")
            guard (self._imageQueue.count() <= self.MAX_GIF_IMAGE_QUEUE) else { return }
            
            self._imageQueue.enqueue(gifImage)
        }
    }
    
    /**
     Pushes to the _GiphyResponseQueue.
     
     Q: Why is this a function if it's basically only one line?
     A: So we can cleanly pass it into a NETWORK callback
     */
    internal func _pushToGiphyResponseQueue(gif : Gif!) {
        self.responseResourceQueueGCD.sync() {
            guard (self._responseQueue.count() <= self.MAX_RESPONSE_AMMOUNT) else { return}
            
            //Don't enqueue a nil gif
            guard (gif != nil) else { return }
            self._responseQueue.enqueue(gif)
            
        }.notify(self.imageModuleQueueGCD) {
            self._addGifImageWork()
        }
    }
    
    /**
     Gets more gif objects and populates the _GiphyResponseQueue
    */
    internal func _getGifObjects() {
        
        guard (self._responseQueue.count() <= self.MAX_RESPONSE_AMMOUNT) else { return}
        
        //giphyManager.search(self._pushToGiphyResponseQueue, onError: NetworkUtility.logError)
    }
    
    /**
     Pulls from the _GifResponseQueue, creates the image, and then populates the _GifImageQueue
    */
    internal func _getGifImages(gif : Gif?) {
        
        guard (gif != nil) else { print("Error: Gif nil?"); return }
        GifImageCreator.findImage(gif, onSuccess: self._pushToGifImageQueue)
    }
    
    
}