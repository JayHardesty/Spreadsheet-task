//
//  Spreadsheet.swift
//  stask
//
//  Created by Jay Hardesty on 25.07.18.
//  Copyright © 2018 Jay Hardesty. All rights reserved.
//

import Foundation

class Spreadsheet {
    static var soleInstance = Spreadsheet()
    
    typealias Size = (rows: Int, columns: Int)
    var size = Size(0, 0)
    var cells: [Cell]?
    
    // MARK: - API
    
    func read(fromURL url: URL, completion: ([Cell]?, Size) -> Void) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            if let cells = build(fromText: text) {
                self.cells = cells
            }
        } catch {
            print(error)
        }
        completion(cells, size)
    }
    
    func cell(forName name: String) -> Cell? {
        guard let cells = cells else {
            return nil
        }
        do {
            return try cellIndex(forName: name).map { cells[$0] }
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - Helpers
    
    private func build(fromText text: String) -> [Cell]? {
        let lines = text.components(separatedBy: .newlines).filter { !$0.isEmpty }
        size.rows = lines.count
        
        let counts = Set(lines.map { $0.components(separatedBy: ",").count })
        guard let count = counts.first, counts.count == 1 else {
            print("Not valid csv format")
            return nil
        }
        size.columns = count
        
        let cells = lines.flatMap { string in string.components(separatedBy: ",").map { formula in Cell(formula) } }
        assert(cells.count == size.rows * size.columns)
        return cells
    }
    
    private func cellIndex(forName name: String) throws -> Int? {
        let regex = try NSRegularExpression(pattern: "[A-Za-z]+")
        let results = regex.matches(in: name, range: NSRange(name.startIndex..., in: name))
        assert(results.count <= 1)
        guard let result = results.first, let range = Range(result.range, in: name) else {
            return nil
        }
        var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        letters += letters.lowercased()
        let columnName = String(name[range])
        let column = columnName.reduce(0) {
            let index = letters.index(of: $1)!
            return $0 * 26 + letters.distance(from: letters.startIndex, to: index) % 26
        }
        
        let rowName = name[name.range(of: columnName)!.upperBound...]
        let row = Int(rowName)! - 1
        
        guard row < size.rows && column < size.columns else {
            return nil
        }
        return row * size.columns + column
    }
}
