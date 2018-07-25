//
//  Calculation.swift
//  stask
//
//  Created by Jay Hardesty on 25.07.18.
//  Copyright © 2018 Jay Hardesty. All rights reserved.
//

import Foundation

class Calculation {
    var formula: [String]
    var stack: Stack<Double>
    
    private let operators: [String: (Double, Double) -> Double] = [
        "+": (+),
        "-": (-),
        "*": (*),
        "/": (/)]
    
    init(_ string: String) {
        formula = string.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if formula.isEmpty {
            formula = ["0"]
        }
        stack = Stack<Double>()
    }
    
    lazy var result: Double? = {
        for item in formula {
            do {
                try processNext(item)
            } catch {
                return nil
            }
        }
        if let n = stack.peek(), stack.count == 1 {
            return n
        } else {
            return nil
        }
    }()
    
    private func processNext(_ item: String) throws {
        if let op = operators[item] {
            if let b = stack.pop(), let a = stack.pop() {
                stack.push(op(a, b))
            } else {
                throw CalculationError.missingData
            }
        } else {
            if let n = Spreadsheet.soleInstance.cell(forName: item)?.calculation.result ?? Double(item) {
                stack.push(n)
            } else {
                throw CalculationError.invalidData
            }
        }
    }
}

enum CalculationError: Error {
    case missingData
    case invalidData
}
