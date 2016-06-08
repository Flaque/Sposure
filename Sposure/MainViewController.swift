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
        self.tableView?.separatorStyle = .None
        
        //Show nav and status bar
        self.navigationController!.navigationBarHidden    = false
        UIApplication.sharedApplication().statusBarHidden = false
        
        
        addChoices()
        addScoreButton()
        addPlusButton()
    }
    
    //Redundantly show the nav bar so we don't have nav glitches
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden    = false
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    // ------------------------ Setup ---------------------- //
    
    /**
     Adds a score button in the nav bar
     */
    private func addScoreButton() {
        let backButton = UIBarButtonItem(title: String(HighScoreManager.getTotalAllTimeScore()), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = Color.redColor()
    }
    
    /**
     Adds a plus button to the nav bar
     */
    private func addPlusButton() {
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(MainViewController.searchFear))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.tintColor = Color.blueColor()
    }
    
    
    /**
     Adds all the choices for the moment
     */
    private func addChoices() {
        let scores = HighScoreManager.getScoresForLastWeek()
        
        form +++ Section()
            <<< GraphRow() {
                $0.days = scores
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
    
    // ----------------------- Searching --------------------- //
    
    /** Display a search bar for user to search a custom fear */
    func searchFear() {
        
    }

}
