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
    
    let gifBuffer = GifBuffer()
    
    //Timer
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFirstGif()
    }
    
    /**
     * Launches a new thread that attempts to pull from the queue
     * If it succeeds, it switches to the main thread and updates the queue
     *
     */
    private func loadFirstGif() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            while(self.isFirstImage) {
                self.pullsAndSets()
            }
        }
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
        
        sender.minimumPressDuration = 0.001
        
        if (sender.state == UIGestureRecognizerState.Began) {
            imageView.startAnimatingGif()
        }
        if (sender.state == UIGestureRecognizerState.Ended) {
            imageView.stopAnimatingGif()
        }
    }
    
    private func checkContinue() {
        guard self.imageView.hasFinishedLooping() else { return }
        
        //dispatch_async(dispatch_get_main_queue()) {
        self.pullsAndSets()
        //}
    }
    
    private func pullsAndSets() {
        gifBuffer.pull(setImage, onEmpty: onNoPull)
    }
    
    private func setImage(gifImage : GifImage) -> Void {
        self.imageView.setGifImage(gifImage.image, manager: gifManager, loopCount: 1)
        
        if (isFirstImage) {
            //imageView.stopAnimatingGif()
            launchGifWatcher()
        }
        
        isFirstImage = false
    }
    
    private func onNoPull() {
        //print("can't pull")
    }
    
}

