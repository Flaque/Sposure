//
//  UIViewController+SposureUtility.swift
//  Sposure
//
//  This file acts as a utility extension to UIViewControllers
//
//  Created by Evan Conrad on 6/4/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//


import Foundation
import UIKit

extension UIViewController {
    
    
    /**
     Adds a linear top to bottom color gradient and sets it as the background
     
     - parameter topColor:    The top color
     - parameter bottomColor: The bottom color
     */
    public func addGradientBackground(topColor : CGColor, bottomColor : CGColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        //The .CGColor is super important here. It will fail with no error if you don't have it.
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
}