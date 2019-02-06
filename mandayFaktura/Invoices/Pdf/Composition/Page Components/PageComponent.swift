//
//  PageComponent.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 06.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

enum PageComponentType: Int {
    case header = 1, buyer, seller
}
protocol PageComponent {
    var height: CGFloat { get }
    var type: PageComponentType { get }
       
    func draw(at: NSPoint)
}
