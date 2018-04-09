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
    }
    
    @IBAction func onBuyersTableViewClicked(_ sender: NSTableView) {
        setDeleteBuyerButtonAvailability()
    }
    func setDeleteBuyerButtonAvailability() {
        self.deleteBuyerButton.isEnabled = self.buyersTableView.selectedRow != -1
    }
    
    @IBAction func onDeleteBuyerButtonClicked(_ sender: NSButton) {
        buyersTableViewDelegate!.remove(at: self.buyersTableView.selectedRow)
        self.buyersTableView.reloadData()
        setDeleteBuyerButtonAvailability()
        
    }
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        self.buyersTableViewDelegate!.save()
    }
}
