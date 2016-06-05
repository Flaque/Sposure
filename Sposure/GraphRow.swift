//
//  GraphRow.swift
//  Sposure
//
//  Created by Evan Conrad on 6/5/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import Eureka
import UIKit

//MARK: WeekDay Enum

public enum WeekDay {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

//MARK: GraphCell

public class GraphCell : Cell<Int>, CellType {
    
    @IBOutlet weak var firstDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var secondDayHeightConstraint  : NSLayoutConstraint!
    @IBOutlet weak var thirdDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var fourthDayHeightConstraint  : NSLayoutConstraint!
    @IBOutlet weak var fifthDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var sixthDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var seventhDayHeightConstraint : NSLayoutConstraint!
    
    
    var days : [Int]?
    
    public override func setup() {
        height = { 150 }
        super.setup()
        self.backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        self.days = (self.row as! GraphRow).days
        
        setHeights(normalizeDaysToHeights(self.days!))
    }
    
    /**
     Finds the max from a list of ints
     
     - parameter array:
     
     - returns: 
     */
    private func findMax(array : [Int]) -> Int {
        var max = array[0]
        
        for el in array {
            if (el > max) { max = el }
        }
        
        return max
    }
    
    /**
     Takes in a days and creates the heights that can be fed into height constants.
     The height is based relative to the maximum.
     
     - parameter days: [Int]
     
     - returns: [CGFloat]
     */
    private func normalizeDaysToHeights(days : [Int]) -> [CGFloat] {
        let max       = findMax(days)
        let maxHeight = 100
        
        var array : [CGFloat] = []
        for day in days {
            let percentage : Double = Double(day) / Double(max)
            
            let height = CGFloat(percentage)*CGFloat(maxHeight)
            array.append(height)
        }
        
        debugPrint(array)
        
        return array
    }
    
    private func setHeights(days : [CGFloat]) {
        guard days.count == 7 else { print("ERROR: There are exactly 7 days in a week. Dumbass."); return }
        
        firstDayHeightConstraint.constant   = days[0]
        secondDayHeightConstraint.constant  = days[1]
        thirdDayHeightConstraint.constant   = days[2]
        fourthDayHeightConstraint.constant  = days[3]
        fifthDayHeightConstraint.constant   = days[4]
        sixthDayHeightConstraint.constant   = days[5]
        seventhDayHeightConstraint.constant = days[6]
    }

}

//MARK: GraphRow

public class GraphRow : Row<Int, GraphCell>, RowType {
    
    var days : [Int]?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<GraphCell>(nibName: "GraphCell")
    }
}