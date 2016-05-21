//
//  ViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 5/20/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import Kingfisher

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: AnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = ["https://media2.giphy.com/media/FiGiRei2ICzzG/200.gif"].map { NSURL(string: $0)! }
        let prefetcher = ImagePrefetcher(urls: urls, optionsInfo: nil, progressBlock: nil, completionHandler: {
            (skippedResources, failedResources, completedResources) -> () in
            
            print(skippedResources)
            print(failedResources)
            print(completedResources)
            //imageView.kf_setImageWithURL(completedResources["downloadURL"])
        })
        prefetcher.start()
        
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.imageView.addGestureRecognizer(tap)
        
        NETWORK.search("cats", onSuccess: setImageToGif)
    }
    
    private func printGifs(response : SearchResponse) -> Void {
        for gif in response.gifs! {
            print(gif.url)
        }
    }
    
    private func setImageToGif(response : SearchResponse) -> Void {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        //imageView.image = gifTwo
    }
    
}

