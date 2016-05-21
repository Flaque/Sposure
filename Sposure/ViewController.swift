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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapRecognition()
        
        NETWORK.search("Same", onSuccess: setImage)
    }
    
    private func addTapRecognition() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.imageView.addGestureRecognizer(tap)
    }
    
    private func setImage(image : UIImage) -> Void {
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        //imageView.image = gifTwo
    }
    
}

