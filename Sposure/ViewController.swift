//
//  ViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 5/20/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var gifImages : [GifImage] = []
    var gifIndex  : Int        = 0
    
    let gifManager    = SwiftyGifManager(memoryLimit:20)
    var updatingImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapRecognition()
        
        NETWORK.search("Spiders", limit: 3, onSuccess: setImage)
    }
    
    private func launchGifWatcher() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            //TODO: Remove this loop? This is probably really inefficient.
            while (true) {
                self.continueGif()
            }
        }
    }
    
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
    }
    
    private func addTapRecognition() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.imageView.addGestureRecognizer(tap)
    }
    
    private func setImage(gifImages : [GifImage]) -> Void {
        self.gifImages.appendContentsOf(gifImages)
        
        setImage()
        launchGifWatcher()
    }
    
    private func setImage() {
        guard (gifIndex + 1 <= gifImages.count) else { return }
        
        let gifImage : GifImage = self.gifImages[gifIndex]
        var loops    : Int      = 1
        
        if (gifImage.image.framesCount() < 10) { loops = 4 }
        
        self.imageView.setGifImage(gifImage.image, manager: gifManager, loopCount: loops)
        updatingImage = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        guard (gifIndex + 1 < gifImages.count) else { return }
        
        gifIndex += 1
        setImage()
    }
    
}

