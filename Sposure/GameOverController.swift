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
    
    @IBAction func onBackButtonPress(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    deinit {
        print("Deinited gameoverController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Focus just on the content
        UIApplication.shared.isStatusBarHidden = true
        
        self.navigationController!.isNavigationBarHidden = true;
        self.addGradientBackground(Color.turquoiseColor().cgColor,
                                   bottomColor: Color.blueColor().cgColor)
        
        scoreLabel.text = String(score as Int!)
    }
    

    
    
}
