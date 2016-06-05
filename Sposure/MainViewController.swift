//
//  MainViewController.swift
//  Sposure
//
//  Created by Evan Conrad on 6/3/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class MainViewController : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientBackground(Color.orangeColor().CGColor, bottomColor: Color.redColor().CGColor)
        self.tableView?.backgroundColor = UIColor.clearColor()
        
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Cats"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
    }
    
    
    //Force white status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
