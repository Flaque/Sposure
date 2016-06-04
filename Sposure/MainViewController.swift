//
//  MainViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 6/3/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import UIKit

class MainViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        //The .CGColor is super important here. It will fail with no error if you don't have it.
        gradient.colors = [Color.orangeColor().CGColor, Color.redColor().CGColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
}
