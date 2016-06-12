//
//  StreamViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 6/4/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import UIKit

class StreamViewController : GifBufferController {
    
    var score : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBarHidden = true;
    }
    
    /**
     On gameover, go to the gameover screen
     
     - parameter time:
     */
    private func gameOver(time : Double) {
        score = Int(time)
        
        addHighScore()
        reloadDelegate.reloadData()
        
        performSegueWithIdentifier("exitGifStream", sender: time)
    }
    
    /**
     Handles the segue
     
     - parameter segue:
     - parameter sender:
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exitGifStream" {
            if let gameOverController = segue.destinationViewController as? GameOverController {
                gameOverController.score = sender as? Int
            }
        }
    }
    
    /** Adds a high score to core data */
    private func addHighScore() {
        HighScoreManager.addScore(score!, category: searchSubject)
    }
    
    /**
     Handles the long press. Starts displaying gifs upon long tap.
     
     - parameter sender:
     */
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        
        guard self.firstImage != nil else { return } // Make sure we have the first image
        
        sender.minimumPressDuration = 0.001
        
        // Set the first image upon long press.
        if (sender.state == UIGestureRecognizerState.Began) {
            self.imageView.setGifImage(self.firstImage!, manager: self.gifManager, loopCount: 1)
            self.readyButton.hidden = true  // Hide the ready button now.
            
            imageView.startAnimatingGif()
            startTime = CFAbsoluteTimeGetCurrent()
        }
        if (sender.state == UIGestureRecognizerState.Ended) {
            imageView.stopAnimatingGif()
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            gameOver(elapsedTime)
        }
    }
}

protocol ReloadDelegate: class {
    func reloadData()
}