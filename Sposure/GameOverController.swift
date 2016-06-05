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
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBarHidden = true;
        
        scoreLabel.text = String(score as Int!)
    }
    
    
}
