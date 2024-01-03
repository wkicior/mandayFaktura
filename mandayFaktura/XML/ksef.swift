//
//  ksef.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import DYXML

let ksefXml = document() {
    node("gpx", attributes: [
        ("xmlns", "http://www.topografix.com/GPX/1/1"),
        ("creator", "byHand"),
        ("version", "1.1"),
        ("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance"),
        ("xsi:schemaLocation", "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd")
    ]) {
            node("wpt", attributes: [("lat", "39.921055008"), ("lon", "3.054223107")]) {
                node("ele", value: "12.863281")
                node("time", value: "2005-05-16T11:49:06Z")
                node("name", value: "Cala Sant Vicenç - Mallorca")
                node("sym", value: "City")
        }
    }
}
