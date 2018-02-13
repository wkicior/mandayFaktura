//
//  NewInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

struct NewInvoiceViewControllerConstants {
    static let INVOICE_ADDED_NOTIFICATION = Notification.Name(rawValue: "InvoiceAdded")
}

class NewInvoiceViewController: NSViewController {
    var invoiceRepository: InvoiceRepository?
    var counterpartyRepository: CounterpartyRepository?
    var itemsTableViewController: ItemsTableViewController?
    
    var selectedPaymentForm: PaymentForm? = PaymentForm.transfer

    @IBOutlet weak var numberTextField: NSTextField!
    @IBOutlet weak var issueDatePicker: NSDatePicker!
    @IBOutlet weak var sellingDatePicker: NSDatePicker!
    @IBOutlet weak var buyerNameTextField: NSTextField!
    @IBOutlet weak var streetAndNumberTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var taxCodeTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var paymentFormPopUp: NSPopUpButtonCell!
    @IBOutlet weak var dueDatePicker: NSDatePicker!
    @IBOutlet weak var itemsTableView: NSTableView!
    @IBOutlet weak var removeItemButton: NSButton!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueDatePicker.dateValue = Date()
        sellingDatePicker.dateValue = Date()
        dueDatePicker.dateValue = Date()
        let appDel = NSApplication.shared.delegate as! AppDelegate
        invoiceRepository = appDel.invoiceRepository
        counterpartyRepository = appDel.counterpartyRepository
        itemsTableViewController = ItemsTableViewController(itemsTableView: itemsTableView)
        itemsTableView.delegate = itemsTableViewController
        itemsTableView.dataSource = itemsTableViewController
        self.removeItemButton.isEnabled = false
    }
    
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        invoiceRepository?.addInvoice(invoice)
        NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
        view.window?.close()
    }
    
    @IBAction func paymentFormPopUpValueChanged(_ sender: NSPopUpButton) {
        selectedPaymentForm = getPaymentFormByTag(sender.selectedTag())
    }
    
    func getPaymentFormByTag(_ tag: Int)-> PaymentForm? {
        switch tag {
        case 0:
            return PaymentForm.transfer
        case 1:
            return PaymentForm.cash
        default:
            return Optional.none
        }
    }
    
    var invoice: Invoice {
        get {
            let seller = self.counterpartyRepository!.getSeller() ?? Counterparty(name: "Firma XYZ", streetAndNumber: "Ulica 1/2", city: "Gdańsk", postalCode: "00-000", taxCode: "123456789", accountNumber: "00 1234 0000 5555 7777")
            let buyer = Counterparty(name: buyerNameTextField.stringValue, streetAndNumber: streetAndNumberTextField.stringValue, city: cityTextField.stringValue, postalCode: postalCodeTextField.stringValue, taxCode: taxCodeTextField.stringValue, accountNumber:"")
            return Invoice(issueDate: issueDatePicker.dateValue, number: numberTextField.stringValue, sellingDate: sellingDatePicker.dateValue, seller: seller, buyer: buyer, items:  self.itemsTableViewController!.items, paymentForm: selectedPaymentForm!, paymentDueDate: self.dueDatePicker.dateValue)
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as? PdfViewController
            vc?.invoice = invoice
        }
    }
    
    @IBAction func onItemsTableViewClicked(_ sender: Any) {
       self.removeItemButton.isEnabled =  self.itemsTableView.selectedRow != -1
    }
    
    @IBAction func onAddItemClicked(_ sender: NSButton) {
        self.itemsTableViewController!.addItem()
        self.itemsTableView.reloadData()
    }
    
    @IBAction func onMinusButtonClicked(_ sender: Any) {
        self.removeItemButton.isEnabled = false
        self.itemsTableViewController!.removeSelectedItem()
        self.itemsTableView.reloadData()
    }
    
    @IBAction func changeAmount(_ sender: NSTextField) {
        self.itemsTableViewController!.changeAmount(sender)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func changeItemNetValue(_ sender: NSTextField) {
        self.itemsTableViewController!.changeItemNetValue(sender)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func changeItemName(_ sender: NSTextField) {
        self.itemsTableViewController!.changeItemName(sender)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func onVatRateSelect(_ sender: NSPopUpButton) {
        let vatRate = Decimal(sender.selectedItem!.tag)
        self.itemsTableViewController!.changeVatRate(row: sender.tag, vatRate: vatRate)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func onUnitOfMeasureSelect(_ sender: NSPopUpButton) {
        self.itemsTableViewController!.changeUnitOfMeasure(row: sender.tag, index: (sender.selectedItem?.tag)!)    }
}
