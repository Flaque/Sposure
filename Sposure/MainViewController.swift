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
        self.navigationController!.navigationBarHidden = false;
        
        
        addChoices()
        addScoreButton()
        addPlusButton()
    }
    
    
    /**
     Adds a score button in the nav bar
     */
    private func addScoreButton() {
        let backButton = UIBarButtonItem(title: "1020", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = Color.redColor()
    }
    
    /**
     Adds a plus button to the nav bar
     */
    private func addPlusButton() {
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .Add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.tintColor = Color.blueColor()
    }
    
    
    /**
     Adds all the choices for the moment
     */
    private func addChoices() {
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Cats"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Not Cats"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Vomit or something"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Just literal dog shit"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Cats"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Not Cats"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Vomit or something"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Just literal dog shit"
                $0.presentationMode = .SegueName(segueName: "toStream", completionCallback: nil)
        }
    }
    
    
    //Force white status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
