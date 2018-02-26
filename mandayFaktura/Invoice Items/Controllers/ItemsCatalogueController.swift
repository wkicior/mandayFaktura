//
//  ItemsCatalogueController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 25.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

class ItemsCatalogueController: NSViewController {
    var itemsCatalogueTableViewController: ItemsCatalogueTableViewController?
    @IBOutlet weak var itemsTableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCatalogueTableViewController = ItemsCatalogueTableViewController(itemsTableView: itemsTableView)
        itemsTableView.delegate = itemsCatalogueTableViewController
        itemsTableView.dataSource = itemsCatalogueTableViewController
    }
}
