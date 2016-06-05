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

public class GraphCell : Cell<Set<WeekDay>>, CellType {
    
    public override func setup() {
        height    = { 150 }
        row.title = nil
        super.setup()
        self.backgroundColor = UIColor.clearColor()
        
        selectionStyle = .None
        
    }

}

//MARK: GraphRow

public class GraphRow : Row<Set<WeekDay>, GraphCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<GraphCell>(nibName: "GraphCell")
    }
}