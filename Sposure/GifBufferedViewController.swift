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
    
    var loader : UIActivityIndicatorView!
    
    //Timer
    var timer = NSTimer()
    
    var searchSubject : String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        gifManager.onLoopEnd = onGifEnd //Tells when the gif is done
    }
    
    deinit {
        print("Deiniting gifBufferController")
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
        loader = UIActivityIndicatorView(frame: CGRect(x: (view.frame.width - dim) / 2, y: (view.frame.height - dim) / 2, width: dim, height: dim))
        loader.tintColor = UIColor.whiteColor()
        loader.startAnimating()
        self.view.addSubview(loader)
        view.bringSubviewToFront(loader)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("View will disappear soon")
        runningGifManager = false //Super fucking important to avoid memory leaks
        isFirstImage      = false
        giphyManager.stop()
        imageManager.stop()
        imageView.stopAnimatingGif() //explicitly stop the animation loop
        gifManager.deleteImageView(imageView) //explicitly delete the image view
        self.imageManager = nil
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
        GCDQueue.Main.async() {
            self.imageView.setGifImage(gifImage.image, manager: self.gifManager, loopCount: 1)
            self.loader.removeFromSuperview()    // remove the loader.
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
     Called when it can't pull.
     */
    private func onNoPull() {
        //print("can't pull")
    }
    
}
