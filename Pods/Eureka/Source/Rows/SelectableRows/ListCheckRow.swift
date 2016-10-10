//
//  ListCheckRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/24/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

open class ListCheckCell<T: Equatable> : Cell<T>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func update() {
        super.update()
        accessoryType = row.value != nil ? .checkmark : .none
        editingAccessoryType = accessoryType
        selectionStyle = .default
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if row.isDisabled {
            tintColor = UIColor(red: red, green: green, blue: blue, alpha: 0.3)
            selectionStyle = .none
        }
        else {
            tintColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
    }
    
    open override func setup() {
        super.setup()
        accessoryType =  .checkmark
        editingAccessoryType = accessoryType
    }
    
    open override func didSelect() {
        row.deselect()
        row.updateCell()
    }
    
}


public final class ListCheckRow<T: Equatable>: Row<T, ListCheckCell<T>>, SelectableRowType, RowType {
    public var selectableValue: T?
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}
