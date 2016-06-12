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
    var firstImage : UIImage?
    
    let giphyManager = GiphyManager()
    var imageManager : ImageManager!
    var runningGifManager = true
    
    var startTime : CFAbsoluteTime!
    
    var loader : UIActivityIndicatorView!
    
    /** Used to reload data on main screen after another score */
    var reloadDelegate : ReloadDelegate!
    
    @IBOutlet weak var readyButton: UIButton!
    
    //Timer
    var timer = NSTimer()
    
    var searchSubject : String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        gifManager.onLoopEnd = onGifEnd //Tells when the gif is done
    }
    
    /**
     Start loading right away
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        giphyManager.start(searchSubject)
        self.imageManager = ImageManager(giphyManager: giphyManager)
        
        loadFirstGif()
        addLoader()
    }
    
    /** Adds a loader while the first GIF is loading */
    private func addLoader() {
        let dim : CGFloat = 50.0
        loader = UIActivityIndicatorView(frame: CGRect(center: self.view.center, size: CGSize(width: dim, height: dim)))
        loader.tintColor = UIColor.whiteColor()
        loader.startAnimating()
        self.view.addSubview(loader)
        view.bringSubviewToFront(loader)
    }
    
    override func viewWillDisappear(animated: Bool) {
        runningGifManager = false //Super fucking important to avoid memory leaks
        isFirstImage      = false
        giphyManager.stop()
        imageManager.stop()
    }
    
    /**
     Gets called once the gif has reached the end of it's loop.
     Pulls the image and disposes of the old one.
     */
    func onGifEnd() {
        GCDQueue.Background.async() {
            self.pullsAndSets()
        }
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
        
        // If first image, don't quite yet display it.
        if self.isFirstImage {
            GCDQueue.Main.async() {
                self.readyButton.hidden = false  // Make the begin button visible now.
                self.loader.removeFromSuperview()    // remove the loader.
                self.firstImage = gifImage.image
            }
        } else  {
            GCDQueue.Main.async() {
               self.imageView.setGifImage(gifImage.image, manager: self.gifManager, loopCount: 1)
            }
        }
        
        if (self.isFirstImage) {
            imageView.stopAnimatingGif()
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
