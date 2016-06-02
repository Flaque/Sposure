//
//  ViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 5/20/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import UIKit
import GCDKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let frontImageManagerGCD : GCDQueue = .createSerial("frontImageManagerGCD")
    
    var gifImages : [GifImage] = []
    var gifIndex  : Int        = 0
    
    let gifManager    = SwiftyGifManager(memoryLimit:20)
    var updatingImage = false
    var isFirstImage  = true
    
    let giphyManager = GiphyManager()
    let imageManager : ImageManager
    
    var startTime : CFAbsoluteTime!
    
    //Timer
    var timer = NSTimer()
    
    required init?(coder aDecoder: NSCoder) {
        giphyManager.start()
        self.imageManager = ImageManager(giphyManager: giphyManager)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFirstGif()
    }
    
    private func gameOver(time : Double) {
        performSegueWithIdentifier("exitGifStream", sender: time)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exitGifStream" {
            if let gameOverController = segue.destinationViewController as? GameOverController {
                gameOverController.score = sender as? Double
            }
        }
    }
    
    /**
     * Launches in the background a queue that attempts to pull from the queue
     * If it succeeds, it switches to the main thread and updates the queue
     *
     */
    private func loadFirstGif() {
        GCDQueue.Background.async() {
            while (self.isFirstImage) {
                self.pullsAndSets()
            }
            
            print("Finished loading the first one")
        }
    }
    
    /**
     * Pull and set the image
     */
    func setImage(gifImage : GifImage) -> Void {
        GCDQueue.Main.async() {
            self.imageView.setGifImage(gifImage.image, manager: self.gifManager, loopCount: 1)
        }
        
        if (self.isFirstImage) {
            imageView.stopAnimatingGif()
            launchGifWatcher()
        }
        
        self.isFirstImage = false
    }
    
    /**
     */
    private func pullsAndSets() {
        
        self.imageManager.pull(self.setImage, onEmpty: self.onNoPull)
    }
    
    
    private func launchGifWatcher() {
        GCDQueue.Background.async() {
            while (true) {
                self.checkContinue()
            }
        }
    }
    
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        
        sender.minimumPressDuration = 0.001
        
        if (sender.state == UIGestureRecognizerState.Began) {
            imageView.startAnimatingGif()
            startTime = CFAbsoluteTimeGetCurrent()
        }
        if (sender.state == UIGestureRecognizerState.Ended) {
            imageView.stopAnimatingGif()
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            gameOver(elapsedTime)
        }
    }
    
    private func checkContinue() {
        GCDQueue.Main.sync() {
            guard self.imageView.hasFinishedLooping() else { return }
            
            GCDQueue.Background.async() {
                self.pullsAndSets()
            }
        }
    }
    
    private func onNoPull() {
        //print("can't pull")
    }
    
}

