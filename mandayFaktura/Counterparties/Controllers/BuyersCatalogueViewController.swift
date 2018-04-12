//
//  BuyersCatalogueViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.04.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class BuyersCatalogueViewController: NSViewController {
    @IBOutlet weak var buyersTableView: NSTableView!
    @IBOutlet weak var deleteBuyerButton: NSButton!
    
    var buyersTableViewDelegate: BuyersTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyersTableViewDelegate = BuyersTableViewDelegate()
        buyersTableView.delegate = buyersTableViewDelegate
        buyersTableView.dataSource = buyersTableViewDelegate
        self.deleteBuyerButton.isEnabled = false
        NotificationCenter.default.addObserver(forName: NewBuyerViewControllerConstants.BUYER_ADDED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                
                                                self.buyersTableViewDelegate?.reloadData()
                                                self.buyersTableView.reloadData()

        }
    }
    
    @IBAction func onBuyersTableViewClicked(_ sender: NSTableView) {
        setDeleteBuyerButtonAvailability()
    }
    func setDeleteBuyerButtonAvailability() {
        self.deleteBuyerButton.isEnabled = self.buyersTableView.selectedRow != -1
    }
    
    @IBAction func onDeleteBuyerButtonClicked(_ sender: NSButton) {
        let modalResponse = deleteAlert.runModal()
        if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
            buyersTableViewDelegate!.remove(at: self.buyersTableView.selectedRow)
            self.buyersTableView.reloadData()
            setDeleteBuyerButtonAvailability()
        }
    }
    
    private var deleteAlert: NSAlert {
        get{
            let alert = NSAlert()
            alert.messageText = "Usunięcie nabywcy!"
            alert.informativeText = "Czy na pewno chcesz usunąć nabywcę z katalogu?"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Usuń")
            alert.addButton(withTitle: "Nie usuwaj")
            return alert
        }
    }
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        self.buyersTableViewDelegate!.save()
    }
}
