//
//  PickerRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/23/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

//MARK: PickerCell

open class PickerCell<T> : Cell<T>, CellType, UIPickerViewDataSource, UIPickerViewDelegate where T: Equatable{
    
    open lazy var picker: UIPickerView = { [unowned self] in
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(picker)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": picker]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": picker]))
        return picker
        }()
    
    fileprivate var pickerRow : _PickerRow<T>? { return row as? _PickerRow<T> }
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        accessoryType = .none
        editingAccessoryType = .none
        picker.delegate = self
        picker.dataSource = self
    }
    
    deinit {
        picker.delegate = nil
        picker.dataSource = nil
    }
    
    open override func update(){
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        picker.reloadAllComponents()
        if let selectedValue = pickerRow?.value, let index = pickerRow?.options.index(of: selectedValue){
            picker.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRow?.options.count ?? 0
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerRow?.displayValueFor?(pickerRow?.options[row])
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let picker = pickerRow , !picker.options.isEmpty {
            picker.value = picker.options[row]
        }
    }
    
}

//MARK: PickerRow

open class _PickerRow<T> : Row<T, PickerCell<T>> where T: Equatable{
    
    open var options = [T]()
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A generic row where the user can pick an option from a picker view
public final class PickerRow<T>: _PickerRow<T>, RowType where T: Equatable {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
