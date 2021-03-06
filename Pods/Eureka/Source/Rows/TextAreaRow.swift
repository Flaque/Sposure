//
//  AlertRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/23/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

public enum TextAreaHeight {
    case fixed(cellHeight: CGFloat)
    case dynamic(initialTextViewHeight: CGFloat)
}

protocol TextAreaConformance: FormatterConformance {
    var placeholder : String? { get set }
    var textAreaHeight : TextAreaHeight { get set }
}


/**
 *  Protocol for cells that contain a UITextView
 */
public protocol AreaCell : TextInputCell {
    var textView: UITextView { get }
}

extension AreaCell {
    public var textInput: UITextInput {
        return textView
    }
}

open class _TextAreaCell<T> : Cell<T>, UITextViewDelegate, AreaCell where T: Equatable, T: InputTypeInitiable {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open lazy var placeholderLabel : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.textColor = UIColor(white: 0, alpha: 0.22)
        return v
    }()
    
    open lazy var textView : UITextView = {
        let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    open var dynamicConstraints = [NSLayoutConstraint]()
    
    open override func setup() {
        super.setup()
        let textAreaRow = row as! TextAreaConformance
        switch textAreaRow.textAreaHeight {
        case .dynamic(_):
            height = { UITableViewAutomaticDimension }
            textView.isScrollEnabled = false
        case .fixed(let cellHeight):
            height = { cellHeight }
        }
        textView.keyboardType = .default
        textView.delegate = self
        textView.font = .preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        placeholderLabel.font = textView.font
        selectionStyle = .none
        contentView.addSubview(textView)
        contentView.addSubview(placeholderLabel)
        
        imageView?.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.old.union(.new), context: nil)
        setNeedsUpdateConstraints()
    }
    
    deinit {
        textView.delegate = nil
        imageView?.removeObserver(self, forKeyPath: "image")
        
    }
    
    open override func update() {
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        textView.isEditable = !row.isDisabled
        textView.textColor = row.isDisabled ? .gray() : .black()
        textView.text = row.displayValueFor?(row.value)
        placeholderLabel.text = (row as? TextAreaConformance)?.placeholder
        placeholderLabel.sizeToFit()
        placeholderLabel.isHidden = textView.text.characters.count != 0
    }
    
    open override func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled && textView.canBecomeFirstResponder
    }
    
    open override func cellBecomeFirstResponder(_ fromDiretion: Direction) -> Bool {
        return textView.becomeFirstResponder()
    }
    
    open override func cellResignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object, let keyPathValue = keyPath, let changeType = change?[NSKeyValueChangeKey.kindKey] , obj === imageView && keyPathValue == "image" && changeType.uintValue == NSKeyValueChange.setting.rawValue {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    //Mark: Helpers
    
    fileprivate func displayValue(useFormatter: Bool) -> String? {
        guard let v = row.value else { return nil }
        if let formatter = (row as? FormatterConformance)?.formatter , useFormatter {
            return textView.isFirstResponder ? formatter.editingString(for: v as! AnyObject) : formatter.string(for: v as! AnyObject)
        }
        return String(describing: v)
    }
    
    //MARK: TextFieldDelegate
    
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        formViewController()?.beginEditing(self)
        formViewController()?.textInputDidBeginEditing(textView, cell: self)
        if let textAreaConformance = (row as? TextAreaConformance), let _ = textAreaConformance.formatter , textAreaConformance.useFormatterOnDidBeginEditing ?? textAreaConformance.useFormatterDuringInput {
            textView.text = self.displayValue(useFormatter: true)
        }
        else {
            textView.text = self.displayValue(useFormatter: false)
        }
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        formViewController()?.endEditing(self)
        formViewController()?.textInputDidEndEditing(textView, cell: self)
        textViewDidChange(textView)
        textView.text = displayValue(useFormatter: (row as? FormatterConformance)?.formatter != nil)
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        
        if let textAreaConformance = row as? TextAreaConformance, case .dynamic = textAreaConformance.textAreaHeight, let tableView = formViewController()?.tableView {
            let currentOffset = tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.setContentOffset(currentOffset, animated: false)
        }
        placeholderLabel.isHidden = textView.text.characters.count != 0
        guard let textValue = textView.text else {
            row.value = nil
            return
        }
        guard let fieldRow = row as? FieldRowConformance, let formatter = fieldRow.formatter else {
            row.value = textValue.isEmpty ? nil : (T.init(string: textValue) ?? row.value)
            return
        }
        if fieldRow.useFormatterDuringInput {
            let value: AutoreleasingUnsafeMutablePointer<AnyObject?> = AutoreleasingUnsafeMutablePointer<AnyObject?>.init(UnsafeMutablePointer<T>.allocate(capacity: 1))
            let errorDesc: AutoreleasingUnsafeMutablePointer<NSString?>? = nil
            if formatter.getObjectValue(value, for: textValue, errorDescription: errorDesc) {
                row.value = value.pointee as? T
                guard var selStartPos = textView.selectedTextRange?.start else { return }
                let oldVal = textView.text
                textView.text = row.displayValueFor?(row.value)
                selStartPos = (formatter as? FormatterProtocol)?.getNewPosition(forPosition: selStartPos, inTextInput: textView, oldValue: oldVal, newValue: textView.text) ?? selStartPos
                textView.selectedTextRange = textView.textRange(from: selStartPos, to: selStartPos)
                return
            }
        }
        else {
            let value: AutoreleasingUnsafeMutablePointer<AnyObject?> = AutoreleasingUnsafeMutablePointer<AnyObject?>.init(UnsafeMutablePointer<T>.allocate(capacity: 1))
            let errorDesc: AutoreleasingUnsafeMutablePointer<NSString?>? = nil
            if formatter.getObjectValue(value, for: textValue, errorDescription: errorDesc) {
                row.value = value.pointee as? T
            }
        }
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return formViewController()?.textInput(textView, shouldChangeCharactersInRange: range, replacementString: text, cell: self) ?? true
    }
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return formViewController()?.textInputShouldBeginEditing(textView, cell: self) ?? true
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return formViewController()?.textInputShouldEndEditing(textView, cell: self) ?? true
    }
    
    open override func updateConstraints(){
        customConstraints()
        super.updateConstraints()
    }
    
    open func customConstraints() {
        contentView.removeConstraints(dynamicConstraints)
        dynamicConstraints = []
        var views : [String: AnyObject] = ["textView": textView, "label": placeholderLabel]
        dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]", options: [], metrics: nil, views: views))
        if let textAreaConformance = row as? TextAreaConformance, case .dynamic(let initialTextViewHeight) = textAreaConformance.textAreaHeight {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textView(>=initialHeight@800)]-|", options: [], metrics: ["initialHeight": initialTextViewHeight], views: views))
        }
        else {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textView]-|", options: [], metrics: nil, views: views))
        }
        if let imageView = imageView, let _ = imageView.image {
            views["imageView"] = imageView
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView]-[textView]-|", options: [], metrics: nil, views: views))
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView]-[label]-|", options: [], metrics: nil, views: views))
        }
        else {
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textView]-|", options: [], metrics: nil, views: views))
            dynamicConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        }
        contentView.addConstraints(dynamicConstraints)
    }
    
}

open class TextAreaCell : _TextAreaCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class AreaRow<T: Equatable, Cell: CellType>: FormatteableRow<T, Cell>, TextAreaConformance where Cell: BaseCell, Cell: TypedCellType, Cell: AreaCell, Cell.Value == T {
    
    open var placeholder : String?
    open var textAreaHeight = TextAreaHeight.fixed(cellHeight: 110)
    
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

open class _TextAreaRow: AreaRow<String, TextAreaCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A row with a UITextView where the user can enter large text.
public final class TextAreaRow: _TextAreaRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}


