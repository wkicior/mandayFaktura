//
//  DatePickerViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 07.05.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

class DatePickerViewController:  NSViewController {
    var relatedDatePicker: NSDatePicker?
    @IBOutlet weak var datePicker: NSDatePicker!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.dateValue = relatedDatePicker!.dateValue
    }
    
    @IBAction func onSelectedDate(_ sender: NSDatePicker) {
        relatedDatePicker!.dateValue = sender.dateValue
    }
}
