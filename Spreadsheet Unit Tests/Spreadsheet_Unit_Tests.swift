//
//  Spreadsheet_Unit_Tests.swift
//  Spreadsheet Unit Tests
//
//  Created by Jay Hardesty on 25.07.18.
//  Copyright © 2018 Jay Hardesty. All rights reserved.
//

import XCTest

class Spreadsheet_Unit_Tests: XCTestCase {
    
    var bundle: Bundle!
    var path: String!
    
    override func setUp() {
        super.setUp()
        bundle = Bundle(for: type(of: self))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBasic() {
        path = bundle.path(forResource: "basic", ofType: "csv")
        let url = URL(fileURLWithPath: path)
        
        Spreadsheet.soleInstance.read(fromURL: url) { cells, _ in
                            // 1, 2
                            // 3, 4
            let expected = ["1.0", "2.0",
                            "3.0", "4.0"]
            XCTAssert(cells!.map { $0.result } == expected)
        }
    }

    func testOps() {
        path = bundle.path(forResource: "ops", ofType: "csv")
        let url = URL(fileURLWithPath: path)
        
        Spreadsheet.soleInstance.read(fromURL: url) { cells, _ in
                            // 1 2 *, 2 3 +
                            // 2 4 /, 2 1 -
            let expected = ["2.0", "5.0",
                            "0.5", "1.0"]
            XCTAssert(cells!.map { $0.result } == expected)
        }
    }
    
    func testCirularity() {
        path = bundle.path(forResource: "circularity", ofType: "csv")
        let url = URL(fileURLWithPath: path)
        
        Spreadsheet.soleInstance.read(fromURL: url) { cells, _ in
                            // A3 A4 +, A1, 2.0, A2
            let expected = ["#ERR", "#ERR", "2.0", "#ERR"]
            XCTAssert(cells!.map { $0.result } == expected)
        }
    }
    
    func testTaskExample() {
        path = bundle.path(forResource: "taskExample", ofType: "csv")
        let url = URL(fileURLWithPath: path)
        
        Spreadsheet.soleInstance.read(fromURL: url) { cells, _ in
                            // b1 b2 +, 2 b2 3 * -, 3, +
                            // a1, 5, , 7 2 /
                            // c2 3 *, 1 2, , 5 1 2 + 4 * + 3 -
            let expected = ["-8.0", "-13.0", "3.0", "#ERR",
                            "-8.0", "5.0", "0.0", "3.5",
                            "0.0", "#ERR", "0.0", "14.0"]
            XCTAssert(cells!.map { $0.result } == expected)
        }
    }
    
    func testTooManyArgs() {
        path = bundle.path(forResource: "tooManyArgs", ofType: "csv")
        let url = URL(fileURLWithPath: path)
        
        Spreadsheet.soleInstance.read(fromURL: url) { cells, _ in
                            // 1 2 3 +
                            // 1 2 +
            let expected = ["#ERR",
                            "3.0"]
            XCTAssert(cells!.map { $0.result } == expected)
        }
    }

    func testTooManyOps() {
        path = bundle.path(forResource: "tooManyOps", ofType: "csv")
        let url = URL(fileURLWithPath: path)

        Spreadsheet.soleInstance.read(fromURL: url) { cells, _ in
            // 1 2 + -, A1
            let expected = ["#ERR", "#ERR"]
            XCTAssert(cells!.map { $0.result } == expected)
        }
    }
    
    func testZeroDivide() {
        path = bundle.path(forResource: "zeroDivide", ofType: "csv")
        let url = URL(fileURLWithPath: path)
        
        Spreadsheet.soleInstance.read(fromURL: url) { cells, _ in
            // 3 1 1 - /
            let expected = ["#ERR"]
            XCTAssert(cells!.map { $0.result } == expected)
        }
    }
}
