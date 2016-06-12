//
//  GameOverController.swift
//  Sposure
//
//  Created by Evan Conrad on 6/1/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import UIKit

class GameOverController : UIViewController {
    
    var score : Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func onBackButtonPress(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    deinit {
        print("Deinited gameoverController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Focus just on the content
        UIApplication.sharedApplication().statusBarHidden = true
        
        self.navigationController!.navigationBarHidden = true;
        self.addGradientBackground(Color.turquoiseColor().CGColor,
                                   bottomColor: Color.blueColor().CGColor)
        
        scoreLabel.text = String(score as Int!)
    }
    

    
    
}
