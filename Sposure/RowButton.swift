//
//  RowButton.swift
//  Sposure
//
//  Created by Evan Conrad on 6/4/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import UIKit


class RowButton : UIView {
    
    func baseInit() {
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textLabel.text = "Hello View"
        textLabel.backgroundColor = UIColor.whiteColor()
    }
    
    /**
     Row buttons get rid of the annoying restrictions that tableviews give
     while still mimicing the UI of a tableview.
     
     - returns: self
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}