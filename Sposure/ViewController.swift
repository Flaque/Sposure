//
//  ViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 5/20/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var gifImages : [GifImage] = []
    var gifIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapRecognition()
        
        NETWORK.search("Same",    limit: 1, onSuccess: setImage)
        NETWORK.search("Cats",    limit: 2, onSuccess: setImage)
        NETWORK.search("Dogs",    limit: 3, onSuccess: setImage)
        NETWORK.search("Bitches", limit: 4, onSuccess: setImage)
        NETWORK.search("Hoes",    limit: 5, onSuccess: setImage)
        
    }
    
    private func addTapRecognition() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.imageView.addGestureRecognizer(tap)
    }
    
    private func setImage(gifImages : [GifImage]) -> Void {
        self.gifImages.appendContentsOf(gifImages)
        
        imageView.image = self.gifImages[gifIndex].image
    }
    
    
    private func setImage() {
        guard (gifIndex + 1 < gifImages.count) else { return }
        
        imageView.image = gifImages[gifIndex].image
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

