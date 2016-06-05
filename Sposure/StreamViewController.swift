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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBarHidden = true;
    }
    
    /**
     On gameover, go to the gameover screen
     
     - parameter time:
     */
    private func gameOver(time : Double) {
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
    
    /**
     Handles the long press
     
     - parameter sender:
     */
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
}