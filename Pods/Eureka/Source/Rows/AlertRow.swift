//
//  AlertRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/23/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation


open class _AlertRow<T: Equatable, Cell: CellType>: OptionsRow<T, Cell>, PresenterRowType where Cell: BaseCell, Cell: TypedCellType, Cell.Value == T {
    
    open var onPresentCallback : ((FormViewController, SelectorAlertController<T>)->())?
    lazy open var presentationMode: PresentationMode<SelectorAlertController<T>>? = {
        return .presentModally(controllerProvider: ControllerProvider.callback { [weak self] in
            let vc = SelectorAlertController<T>(title: self?.selectorTitle, message: nil, preferredStyle: .alert)
            vc.row = self
            return vc
            }, completionCallback: { [weak self] in
                $0.dismiss(animated: true, completion: nil)
                self?.cell?.formViewController()?.tableView?.reloadData()
            }
        )
    }()
    
    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
    open override func customDidSelect() {
        super.customDidSelect()
        if let presentationMode = presentationMode , !isDisabled  {
            if let controller = presentationMode.createController(){
                controller.row = self
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.presentViewController(controller, row: self, presentingViewController: cell.formViewController()!)
            }
            else{
                presentationMode.presentViewController(nil, row: self, presentingViewController: cell.formViewController()!)
            }
        }
    }
}

/// An options row where the user can select an option from a modal Alert
public final class AlertRow<T: Equatable>: _AlertRow<T, AlertSelectorCell<T>>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

