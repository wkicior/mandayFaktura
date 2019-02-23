//
//  InvoiceDatesViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 20.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct InvoiceDatesViewControllerConstants {
    static let ISSUE_DATE_SELECTED_NOTIFICATION = Notification.Name(rawValue: "IssueDateSelected")
    static let SELLING_DATE_SELECTED_NOTIFICATION = Notification.Name(rawValue: "SellingDateSelected")
    
    static let ISSUE_DATE_NOTIFICATION_KEY = "issueDate"
    static let SELLING_DATE_NOTIFICATION_KEY = "sellingDate"
}

class InvoiceDatesViewController: NSViewController {
    let invoiceSettingsFacade = InvoiceSettingsFacade()
    @IBOutlet weak var issueDatePicker: NSDatePicker!
    @IBOutlet weak var sellingDatePicker: NSDatePicker!
    
    private var _sellingDate: Date = Date()
    private var _issueDate: Date = Date()
    
    var issueDate: Date {
        get {
            return self.issueDatePicker.dateValue
        }
        set (value) {
            self._issueDate = value
        }
    }
    
    var sellingDate: Date {
        get {
            return self.sellingDatePicker.dateValue
        }
        set (value) {
            self._sellingDate = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sellingDatePicker?.dateValue = _sellingDate
        self.issueDatePicker?.dateValue = _issueDate
      
    }
    
    @IBAction func onIssueDateSelected(_ sender: NSDatePicker) {
        let dateDict:[String: Any] = [InvoiceDatesViewControllerConstants.ISSUE_DATE_NOTIFICATION_KEY: self.issueDatePicker.dateValue as Any]
        NotificationCenter.default.post(name: InvoiceDatesViewControllerConstants.ISSUE_DATE_SELECTED_NOTIFICATION, object: nil, userInfo: dateDict)
    }
    
    @IBAction func onSellDateSelected(_ sender: NSDatePicker) {
        let dateDict:[String: Any] = [InvoiceDatesViewControllerConstants.SELLING_DATE_NOTIFICATION_KEY: self.sellingDatePicker.dateValue as Any]
        NotificationCenter.default.post(name: InvoiceDatesViewControllerConstants.SELLING_DATE_SELECTED_NOTIFICATION, object: nil, userInfo: dateDict)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
       if segue.destinationController is DatePickerViewController {
            let vc = segue.destinationController as! DatePickerViewController
            if segue.identifier == NSStoryboardSegue.Identifier("issueDatePickerSegue") {
                vc.relatedDatePicker = self.issueDatePicker
                vc.onSelectedDateAction = #selector(self.onIssueDateSelected(_:))
            } else if segue.identifier == NSStoryboardSegue.Identifier("sellingDatePickerSegue") {
                vc.relatedDatePicker = self.sellingDatePicker
                vc.onSelectedDateAction = #selector(self.onSellDateSelected(_:))
            }
         vc.onSelectedDateActionTarget = self
        }
    }
}
