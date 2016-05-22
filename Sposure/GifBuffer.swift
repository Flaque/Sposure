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
    
    /**
     Boots up the modules
    */
    init() {
        
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
        _GifImageQueue.enqueue(gifImage)
    }
    
    /**
     Pushes to the _GiphyResponseQueue.
     
     Q: Why is this a function if it's basically only one line?
     A: So we can cleanly pass it into a NETWORK callback
     */
    private func _pushToGiphyResponseQueue(gif : Gif) {
        _GiphyResponseQueue.enqueue(gif)
    }
    
    /**
     Gets more gif objects and populates the _GiphyResponseQueue
    */
    private func _getGifObjects() {
        GiphyManager.search(_pushToGiphyResponseQueue)
    }
    
    private func _getGifImages() {
        
    }
}