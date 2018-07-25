//
//  main.swift
//  SpreadsheetTask
//
//  Created by Jay Hardesty on 25.07.18.
//  Copyright © 2018 Jay Hardesty. All rights reserved.
//

import Foundation

guard let file = CommandLine.arguments.last, CommandLine.arguments.count == 2, file.hasSuffix(".csv") else {
    print("Usage: stask <input file>")
    exit(0)
}

let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(file)

Spreadsheet.soleInstance.read(fromURL: url) { cells, size in
    guard let cells = cells else {
        return
    }
    for row in 0..<size.rows {
        for column in 0..<size.columns {
            let cell = cells[row * size.columns + column]
            print(String(cell.result), terminator: ",")
        }
        print("")
    }
}
