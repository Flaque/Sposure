//
//  GenericMultipleSelectorRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/24/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation



/// Generic options selector row that allows multiple selection.
open class GenericMultipleSelectorRow<T: Hashable, Cell: CellType, VCType: TypedRowControllerType>: Row<Set<T>, Cell>, PresenterRowType, NoValueDisplayTextConformance where Cell: BaseCell, Cell: TypedCellType, Cell.Value == Set<T>, VCType: UIViewController, VCType.RowValue == Set<T> {
    
    /// Defines how the view controller will be presented, pushed, etc.
    open var presentationMode: PresentationMode<VCType>?
    
    /// Will be called before the presentation occurs.
    open var onPresentCallback : ((FormViewController, VCType)->())?
    
    /// Title to be displayed for the options
    open var selectorTitle: String?
    
    open var noValueDisplayText: String?
    
    /// Options from which the user will choose
    open var options: [T] {
        get { return self.dataProvider?.arrayData?.map({ $0.first! }) ?? [] }
        set { self.dataProvider = DataProvider(arrayData: newValue.map({ Set<T>(arrayLiteral: $0) })) }
    }
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = { (rowValue: Set<T>?) in
            return rowValue?.map({ String(describing: $0) }).joined(separator: ", ")
        }
        presentationMode = .show(controllerProvider: ControllerProvider.callback { return VCType() }, completionCallback: { vc in vc.navigationController?.popViewController(animated: true) })
    }
    
    /**
     Extends `didSelect` method
     */
    open override func customDidSelect() {
        super.customDidSelect()
        guard let presentationMode = presentationMode , !isDisabled else { return }
        if let controller = presentationMode.createController(){
            controller.row = self
            controller.title = selectorTitle ?? controller.title
            onPresentCallback?(cell.formViewController()!, controller)
            presentationMode.presentViewController(controller, row: self, presentingViewController: self.cell.formViewController()!)
        }
        else{
            presentationMode.presentViewController(nil, row: self, presentingViewController: self.cell.formViewController()!)
        }
    }
    
    /**
     Prepares the pushed row setting its title and completion callback.
     */
    open override func prepareForSegue(_ segue: UIStoryboardSegue) {
        super.prepareForSegue(segue)
        guard let rowVC = segue.destination as? VCType else { return }
        rowVC.title = selectorTitle ?? rowVC.title
        rowVC.completionCallback = presentationMode?.completionHandler ?? rowVC.completionCallback
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
    }
}

