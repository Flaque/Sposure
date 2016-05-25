//
//  ViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 5/20/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var gifImages : [GifImage] = []
    var gifIndex  : Int        = 0
    
    let gifManager    = SwiftyGifManager(memoryLimit:20)
    var updatingImage = false
    var isFirstImage  = true
    
    //let gifBuffer = GifBuffer()
    
    //Timer
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NETWORK.search("Cats", limit: 3, onSuccess: setImage)
        
        //while (isFirstImage) {
            //pullsAndSets()
        //}
    }
    
    private func launchGifWatcher() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            //TODO: Remove this loop? This is probably really inefficient.
            while (true) {
                self.checkContinue()
            }
        }
    }
    
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        
        print("long press")
        
        if (sender.state == UIGestureRecognizerState.Began) {
            print("started")
            imageView.startAnimatingGif()
        }
        if (sender.state == UIGestureRecognizerState.Ended) {
            print("ended")
            imageView.stopAnimatingGif()
        }
    }

    /*
    private func continueGif() {
        
        //Fail if we're past what we've loaded
        guard (gifIndex + 1 <= gifImages.count) else { return }
        
        //Fail if we're still animating
        guard (imageView.hasFinishedLooping()) else { return }
        
        //If we're already updating, don't continue this bullshit.
        guard (!updatingImage) else { return }
        
        
        //If this is the first time, we're going to lock.
        updatingImage = true
        
        //Increment
        gifIndex += 1
        
        //Update gif
        dispatch_async(dispatch_get_main_queue()) {
            self.setImage()
        }
    } */
    
    private func checkContinue() {
        guard self.imageView.hasFinishedLooping() else { return }
        
        pullsAndSets()
    }
    
    private func pullsAndSets() {
        //gifBuffer.pull(setImage, onEmpty: onNoPull)
    }
    
    private func setImage(gifImage : GifImage) -> Void {
        self.imageView.setGifImage(gifImage.image, manager: gifManager, loopCount: 1)
        
        if (isFirstImage) { launchGifWatcher() }
        
        isFirstImage = false
    }
    
    private func onNoPull() {
        //Do nothing?
    }
    
    /**
     Callback to network request. Set images and also supply more gifImages
 
    private func setImage(gifImages : [GifImage]) -> Void {
        self.gifImages.appendContentsOf(gifImages)
        
        setImage()
        launchGifWatcher()
    }
    
    /**
     Set the image (based on the global counter)
    */
    private func setImage() {
        guard (gifIndex + 1 <= gifImages.count) else { return }
        
        let gifImage : GifImage = self.gifImages[gifIndex]
        var loops    : Int      = 1
        
        //If the gif is too short, repeat it a couple times
        if (gifImage.image.framesCount() < 10) { loops = 3 }
        
        self.imageView.setGifImage(gifImage.image, manager: gifManager, loopCount: loops)
        
        //If we're the first image, let's pause
        if (gifIndex == 0) { self.imageView.stopAnimatingGif() }
        
        //Make sure we're not already updating the image
        updatingImage = false
    } */
}

