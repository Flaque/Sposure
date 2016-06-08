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
    
    var scoreButton : UIBarButtonItem!
    var searchBar : UISearchBar!
    var toStreamSegue = "toStream"
    var tapRecognizer : UITapGestureRecognizer!
    
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
        addSearchBar()
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
        scoreButton = UIBarButtonItem(title: String(HighScoreManager.getTotalAllTimeScore()), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = scoreButton
        self.navigationItem.leftBarButtonItem?.tintColor = Color.redColor()
    }
    
    /**
     Adds a plus button to the nav bar
     */
    private func addPlusButton() {
        let plusButton = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(MainViewController.searchFear))
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.rightBarButtonItem?.tintColor = Color.blueColor()
    }
    
    /**
     Adds a search bar to the middle of the nav bar.
     */
    private func addSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 50.0, y: 10.0, width: self.view.frame.width - 85.0, height: 30.0))
        searchBar.delegate = self
        let searchBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.setLeftBarButtonItems([scoreButton, searchBarButton], animated: true)
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
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Not Cats"
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Vomit or something"
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Just literal dog shit"
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Cats"
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Not Cats"
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Vomit or something"
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
            }
            <<< ButtonRow() {
                $0.title = "Just literal dog shit"
                $0.presentationMode = .SegueName(segueName: toStreamSegue, completionCallback: nil)
        }
    }
    
    
    //Force white status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    /** Invoked when user presses plus button */
    func searchFear() {


    }

}

// ----------------------- Searching --------------------- //
extension MainViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        addTapToDismissKeyboard()   // Add the tap to dismiss control.
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer) // Remove tap to dimiss control so other elements can be pressed.
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    }
    
    /** Search what they typed in on Giffy */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)              // Have to dismiss keyboard this way.
        let text = searchBar.text!
        self.performSegueWithIdentifier(toStreamSegue, sender: self)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    /**
     Adds a tap recognizer to dismiss the keyboard.
     */
    private func addTapToDismissKeyboard() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }

    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}
