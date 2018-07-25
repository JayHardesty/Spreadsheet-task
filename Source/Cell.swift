//
//  Cell.swift
//  stask
//
//  Created by Jay Hardesty on 25.07.18.
//  Copyright © 2018 Jay Hardesty. All rights reserved.
//

import Foundation

class Cell : Equatable {
    let calculation: Calculation
    let string: String
    
    init(_ string: String) {
        calculation = Calculation(string)
        self.string = string
    }

    var result: String {
        if !hasCircularity() {
            if let n = calculation.result {
                return String(n)
            }
        }
        return "#ERR"
    }
    
    private var immediateDependencies: [Cell] {
        return string.components(separatedBy: .whitespaces).compactMap { Spreadsheet.soleInstance.cell(forName: $0) }
    }
    
    private func hasCircularity(withCell cell: Cell? = nil) -> Bool {
        if let cell = cell, cell == self {
            return true
        }
        let dependencies = (cell ?? self).immediateDependencies
        for dependent in dependencies {
            if hasCircularity(withCell: dependent) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs === rhs
    }
}
