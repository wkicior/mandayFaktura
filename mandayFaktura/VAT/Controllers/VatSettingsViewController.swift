//
//  VatSettingsViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 10.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class VatSettingsViewController: NSViewController {
    var vatRatesTableViewDelegate: VatRatesTableViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        vatRatesTableViewDelegate = VatRatesTableViewDelegate(vatRatesTableView: vatTableView)
        self.vatTableView.delegate = vatRatesTableViewDelegate!
        self.vatTableView.dataSource = vatRatesTableViewDelegate!
    }
    @IBOutlet weak var vatTableView: NSTableView!
    @IBOutlet weak var addVatRateButton: NSButton!
    @IBOutlet weak var removeVatRateButton: NSButton!
    @IBAction func onAddVatRateButtonClicked(_ sender: NSButton) {
        
    }
    @IBAction func onDeleteVatRateButtonClicked(_ sender: NSButton) {
        vatRatesTableViewDelegate!.removeSelectedItem()
        self.vatTableView.reloadData()
    }
}
