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
    
    var score : Double?
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(score)
        
        scoreLabel.text = String(score as Double!)
    }
    
    
}
