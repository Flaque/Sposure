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
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

//MARK: GraphCell

open class GraphCell : Cell<Int>, CellType {
    
    @IBOutlet weak var firstDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var secondDayHeightConstraint  : NSLayoutConstraint!
    @IBOutlet weak var thirdDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var fourthDayHeightConstraint  : NSLayoutConstraint!
    @IBOutlet weak var fifthDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var sixthDayHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var seventhDayHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    
    
    var days : [Int]?
    
    open override func setup() {
        height = { 150 }
        super.setup()
        self.backgroundColor = UIColor.clear
        selectionStyle = .none
        
        self.days = (self.row as! GraphRow).days
        
        setHeights(normalizeDaysToHeights(self.days!))
        setDays()
    }
    
    /**
     Finds the max from a list of ints
     
     - parameter array:
     
     - returns: 
     */
    fileprivate func findMax(_ array : [Int]) -> Int {
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
    fileprivate func normalizeDaysToHeights(_ days : [Int]) -> [CGFloat] {
        let max       = findMax(days)
        let maxHeight = 100
        
        if max == 0 {
            return [0,0,0,0,0,0,0]  // Avoid a divide by zero error
        }
        
        var array : [CGFloat] = []
        for day in days {
            let percentage : Double = Double(day) / Double(max)
            
            let height = CGFloat(percentage)*CGFloat(maxHeight)
            array.append(height)
        }
        
        return array
    }
    
    fileprivate func setHeights(_ days : [CGFloat]) {
        guard days.count == 7 else { print("ERROR: There are exactly 7 days in a week. Dumbass."); return }
        
        firstDayHeightConstraint.constant   = days[0]
        secondDayHeightConstraint.constant  = days[1]
        thirdDayHeightConstraint.constant   = days[2]
        fourthDayHeightConstraint.constant  = days[3]
        fifthDayHeightConstraint.constant   = days[4]
        sixthDayHeightConstraint.constant   = days[5]
        seventhDayHeightConstraint.constant = days[6]
    }

    fileprivate func setDays() {
        let days = DayUtility.getWeekdaysinOrder()
        
        firstLabel.text = days[0]
        secondLabel.text = days[1]
        thirdLabel.text = days[2]
        fourthLabel.text = days[3]
        fifthLabel.text = days[4]
        sixthLabel.text = days[5]
        seventhLabel.text = days[6]
    }
}

//MARK: GraphRow

open class GraphRow : Row<Int, GraphCell>, RowType {
    
    var days : [Int]?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<GraphCell>(nibName: "GraphCell")
    }
}
