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

class MainViewController : FormViewController, ReloadDelegate {
    
    var scoreButton : UIBarButtonItem!
    var searchBar : UISearchBar!
    var toStreamSegue = "toStream"
    var tapRecognizer : UITapGestureRecognizer!
    var searchSubject : String = "Cats"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientBackground(Color.orangeColor().CGColor, bottomColor: Color.redColor().CGColor)
        self.tableView?.backgroundColor = UIColor.clearColor()
        self.tableView?.separatorStyle = .None
        
        //Show nav and status bar
        self.navigationController!.navigationBarHidden    = false
        UIApplication.sharedApplication().statusBarHidden = false
        
        
        addScoreGraph()
        addSearchSuggestions()
        addScoreButton()
        addPlusButton()
        addSearchBar()
    }
    
    //Redundantly show the nav bar so we don't have nav glitches
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden    = false
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as? GifBufferController
        controller?.searchSubject = self.searchSubject
        controller?.reloadDelegate = self
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
     Reloads the scores in the UI. Called when user returns from game over screen.
     */
    func reloadData() {
        
        // Reset score
        scoreButton.title = String(HighScoreManager.getTotalAllTimeScore())
        
        // Reset graph and search suggestions.
        form.removeAll()
        addScoreGraph()
        addSearchSuggestions()
    }
    
    /**
     Adds the graph of scores
     */
    private func addScoreGraph() {
        let scores = HighScoreManager.getScoresForLastWeek()
        
        form +++ Section()
            <<< GraphRow("scores") {
                $0.days = scores
            }
    }
    
    /**
     Adds the search suggestions.
     */
    private func addSearchSuggestions() {
        
        // Loop through defaults, adding them to table.
        for subject in SearchSubjectsManager.getSortedSearchSubjects() {
            form.first! <<< ButtonRow(subject) {
                $0.title = $0.tag
                
                $0.onCellSelection({ (cell, row) in
                    self.searchSubject = cell.textLabel!.text!  // Record what subject user selected
                    self.performSegueWithIdentifier(self.toStreamSegue, sender: self)
                })
                }.cellUpdate({ (cell, row) in
                    cell.accessoryType = .DisclosureIndicator
                    cell.textLabel?.textAlignment = .Left
                    cell.textLabel?.textColor = UIColor.blackColor()
                }) //https://github.com/xmartlabs/Eureka/issues/3
            // This styles the cells so that it appears they are disclosing another page.
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
        searchBar.endEditing(true)      // Have to dismiss keyboard this way.
        
        searchSubject = searchBar.text! // extract the search subject.
        searchBar.text = ""     // clear search field for next time.
        
        SearchSubjectsManager.addSearch(searchSubject)  // save search to device.
        
        self.performSegueWithIdentifier(toStreamSegue, sender: self)  // Go to the image stream screen.
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
