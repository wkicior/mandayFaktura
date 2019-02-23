//
//  PaymentDetailsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 20.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class PaymentDetailsViewController : NSViewController {
    private let invoiceSettingsFacade = InvoiceSettingsFacade()

    @IBOutlet weak var paymentFormPopUpx: NSPopUpButton!
    @IBOutlet weak var paymentFormPopUp: NSPopUpButtonCell!
    @IBOutlet weak var dueDatePicker: NSDatePicker!

    private var _dueDate: Date = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
    private var _paymentForm: PaymentForm? = PaymentForm.transfer
    
    var dueDate: Date {
        set(value) {
            self._dueDate = value
        }
        get {
            return self.dueDatePicker.dateValue
        }
    }
    
    var paymentForm: PaymentForm? {
        set(value) {
            self._paymentForm = value
        }
        get {
            return self._paymentForm
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDatePicker.dateValue = self._dueDate
        if (self._paymentForm != nil) {
            let tag = getPaymentFormTag(from: self._paymentForm!)
            self.paymentFormPopUp.selectItem(withTag: tag)
        }

        NotificationCenter.default.addObserver(forName: InvoiceDatesViewControllerConstants.ISSUE_DATE_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.onIssueDateSelected(notification: notification)}
        NotificationCenter.default.addObserver(forName: InvoiceDatesViewControllerConstants.SELLING_DATE_SELECTED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in self.onSellingDateSelected(notification: notification)}
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is DatePickerViewController {
            let vc = segue.destinationController as! DatePickerViewController
            if segue.identifier == NSStoryboardSegue.Identifier("dueDatePickerSegue") {
                vc.relatedDatePicker = self.dueDatePicker
            }
        }
    }
    
    @IBAction func paymentFormPopUpValueChanged(_ sender: NSPopUpButton) {
        self._paymentForm = getPaymentFormByTag(sender.selectedTag())
    }
    
    func getPaymentFormByTag(_ tag: Int) -> PaymentForm? {
        switch tag {
        case 0:
            return PaymentForm.transfer
        case 1:
            return PaymentForm.cash
        default:
            return Optional.none
        }
    }
    
    func getPaymentFormTag(from: PaymentForm) -> Int {
        switch from {
        case .transfer:
            return 0
        case .cash:
            return 1
        }
    }
    
    func onIssueDateSelected(notification: Notification) {
        let userInfo = notification.userInfo as NSDictionary?
        let issueDate = userInfo?[InvoiceDatesViewControllerConstants.ISSUE_DATE_NOTIFICATION_KEY] as! Date
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
        if (invoiceSettings != nil && invoiceSettings!.paymentDateFrom == .issueDate) {
            self.dueDatePicker.dateValue = invoiceSettings!.getDueDate(date: issueDate)
        }
    }
    
    func  onSellingDateSelected(notification: Notification) {
        let userInfo = notification.userInfo as NSDictionary?
        let sellingDate = userInfo?[InvoiceDatesViewControllerConstants.SELLING_DATE_NOTIFICATION_KEY] as! Date
        let invoiceSettings = self.invoiceSettingsFacade.getInvoiceSettings()
        if (invoiceSettings != nil && invoiceSettings!.paymentDateFrom == .sellDate) {
            self.dueDatePicker.dateValue = invoiceSettings!.getDueDate(date: sellingDate)
        }
    }

}
