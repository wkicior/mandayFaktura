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
    let counterpartyInteractor = CounterpartyInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyersTableViewDelegate = BuyersTableViewDelegate(counterpartyInteractor: counterpartyInteractor)
        buyersTableView.delegate = buyersTableViewDelegate
        buyersTableView.dataSource = buyersTableViewDelegate
        self.deleteBuyerButton.isEnabled = false
        buyersTableView.doubleAction = #selector(onTableViewClicked)
        NotificationCenter.default.addObserver(forName: NewBuyerViewControllerConstants.BUYER_ADDED_NOTIFICATION,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.buyersTableViewDelegate?.reloadData()
                                                self.buyersTableView.reloadData()
        }
        NotificationCenter.default.addObserver(forName: EditBuyerViewControllerConstants.BUYER_EDITED_NOTIFICATION,
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
       deleteSelectedBuyer()
    }
    
    private func deleteSelectedBuyer() {
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
   
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
       if segue.destinationController is AbstractBuyerController {
            let vc = segue.destinationController as? EditBuyerController
            let index = self.buyersTableView.selectedRow
            vc?.buyer = buyersTableViewDelegate?.getSelectedBuyer(index: index)
        }
    }
    
    @objc func onTableViewClicked(sender: AnyObject) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "editBuyerSegue"), sender: sender)
    }
    
    override func keyDown(with: NSEvent) {
        super.keyDown(with: with)
        if with.keyCode == 51 && self.buyersTableView.selectedRow != -1 {
            deleteSelectedBuyer()
        }
    }
}
