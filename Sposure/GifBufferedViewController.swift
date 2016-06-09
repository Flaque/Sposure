//
//  ViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 5/20/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import UIKit
import GCDKit

class GifBufferController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let frontImageManagerGCD : GCDQueue = .createSerial("frontImageManagerGCD")
    
    var gifImages : [GifImage] = []
    var gifIndex  : Int        = 0
    
    let gifManager    = SwiftyGifManager(memoryLimit:20)
    var updatingImage = false
    var isFirstImage  = true
    
    let giphyManager = GiphyManager()
    var imageManager : ImageManager!
    var runningGifManager = true
    
    var startTime : CFAbsoluteTime!
    
    //Timer
    var timer = NSTimer()
    
    var searchSubject : String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Start loading right away
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        giphyManager.start(searchSubject)
        self.imageManager = ImageManager(giphyManager: giphyManager)

        loadFirstGif()
    }
    
    override func viewWillDisappear(animated: Bool) {
        runningGifManager = false //Super fucking important to avoid memory leaks
        isFirstImage      = false
        giphyManager.stop()
        imageManager.stop()
    }
    
    /**
     * Launches in the background a queue that attempts to pull from the queue
     * If it succeeds, it switches to the main thread and updates the queue
     *
     */
    private func loadFirstGif() {
        print("attempting to load first Gif")
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
     Pulls from the image manager and sets the image
     */
    private func pullsAndSets() {
        
        self.imageManager.pull(self.setImage, onEmpty: self.onNoPull)
    }
    
    /**
     Launches the gif watcher
     */
    private func launchGifWatcher() {
        GCDQueue.Background.async() {
            while (self.runningGifManager) {
                self.checkContinue()
            }
        }
    }
    
    /**
     Checks if the image is finished looping.
     */
    private func checkContinue() {
        GCDQueue.Main.sync() {
            guard self.imageView.hasFinishedLooping() else { return }
            
            GCDQueue.Background.async() {
                self.pullsAndSets()
            }
        }
    }
    
    /**
     Called when it can't pull.
     */
    private func onNoPull() {
        //print("can't pull")
    }
    
}

