//
//  ItemsCatalogueController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

class ItemsCatalogueController: NSViewController {
    var itemsCatalogueTableViewDelegate: ItemsCatalogueTableViewDelegate?
    var newInvoiceController: NewInvoiceViewController?
    @IBOutlet weak var itemsTableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCatalogueTableViewDelegate = ItemsCatalogueTableViewDelegate(itemsTableView: itemsTableView)
        itemsTableView.delegate = itemsCatalogueTableViewDelegate
        itemsTableView.dataSource = itemsCatalogueTableViewDelegate
        itemsTableView.doubleAction = #selector(onTableViewClicked)
    }
    
    @objc func onTableViewClicked(sender: AnyObject) {
        let invoice = itemsCatalogueTableViewDelegate!.getSelectedInvoice(index: sender.selectedRow)
        newInvoiceController!.addItem(itemDefinition: invoice)
    }
}
