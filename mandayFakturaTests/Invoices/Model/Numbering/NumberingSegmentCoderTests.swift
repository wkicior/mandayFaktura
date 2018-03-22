//
//  NumberingTemplateTests.swift
//  mandayFakturaTests
//
//  Created by Wojciech Kicior on 15.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import XCTest
@testable import mandayFaktura

class NumberingSegmentCoderTests: XCTestCase {
    
    func testDecodeNumber_decodes_incrementingNumber_fixedPart_year() {
        let numberingTemplate = NumberingSegmentCoder(delimeter: "/", segmentTypes: [.incrementingNumber, .fixedPart, .year])
        let segments = numberingTemplate.decodeNumber(invoiceNumber: "1234/B14/2018")
        XCTAssertEqual("1234", segments![0].fixedValue, "invoice numbers must match")
        XCTAssertEqual(.incrementingNumber, segments![0].type, "invoice numbers must match")
        
        XCTAssertEqual("B14", segments![1].fixedValue, "invoice fixed parts must match")
        XCTAssertEqual(.fixedPart, segments![1].type, "invoice fixed parts must match")
        
        XCTAssertEqual("2018", segments![2].fixedValue, "invoice year must match")
        XCTAssertEqual(.year, segments![2].type, "invoice fixed parts must match")

    }
    
    func testDecodeNumber_decodes_fixedPart_year_incrementingNumber() {
        let numberingTemplate = NumberingSegmentCoder(delimeter: "/", segmentTypes: [.fixedPart, .year, .incrementingNumber])
        let segments = numberingTemplate.decodeNumber(invoiceNumber: "B/2018/2")
        
        XCTAssertEqual("B", segments![0].fixedValue, "invoice fixed parts must match")
        XCTAssertEqual(.fixedPart, segments![0].type, "invoice fixed parts must match")
        
        XCTAssertEqual("2018", segments![1].fixedValue, "invoice year must match")
        XCTAssertEqual(.year, segments![1].type, "invoice fixed parts must match")
        
        XCTAssertEqual("2", segments![2].fixedValue, "invoice numbers must match")
        XCTAssertEqual(.incrementingNumber, segments![2].type, "invoice numbers must match")
        
    }
    
    func testDecodeNumber_decodes_fixedPart_incrementingNumber_fixedPart() {
        let numberingTemplate = NumberingSegmentCoder(delimeter: "/", segmentTypes: [.fixedPart, .incrementingNumber, .fixedPart])
        let segments = numberingTemplate.decodeNumber(invoiceNumber: "BAR/2/FOO")
        
        XCTAssertEqual("BAR", segments![0].fixedValue, "invoice fixed parts must match")
        XCTAssertEqual(.fixedPart, segments![0].type, "invoice fixed parts must match")
        
        XCTAssertEqual("2", segments![1].fixedValue, "invoice numbers must match")
        XCTAssertEqual(.incrementingNumber, segments![1].type, "invoice numbers must match")
        
        XCTAssertEqual("FOO", segments![2].fixedValue, "invoice fixed parts must match")
        XCTAssertEqual(.fixedPart, segments![2].type, "invoice fixed parts must match")
        
    }
    
    func testDecodeNumber_returns_nil_on_not_matched() {
        let numberingTemplate = NumberingSegmentCoder(delimeter: "/", segmentTypes: [.fixedPart, .incrementingNumber, .fixedPart])
        let segments = numberingTemplate.decodeNumber(invoiceNumber: "FOOBAR")
        XCTAssertNil(segments, "segments should be nil")
    }
    
    
    func testEncodeNumber() {
        let numberingTemplate = NumberingSegmentCoder(delimeter: "/", segmentTypes: [.incrementingNumber, .fixedPart, .year])
        let segments = [NumberingSegment(type: .incrementingNumber, value: "13"), NumberingSegment(type: .year, value: "2018")]
        let invoiceNumber = numberingTemplate.encodeNumber(segments: segments)
        XCTAssertEqual("13/2018", invoiceNumber, "invoice numbers must match")
        
    }
    
}
