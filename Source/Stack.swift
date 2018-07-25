//
//  Stack.swift
//  stask
//
//  Created by Jay Hardesty on 25.07.18.
//  Copyright © 2018 Jay Hardesty. All rights reserved.
//

import Foundation

struct Stack<T> {
    var array: [T] = []
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    func peek() -> T? {
        return array.last
    }
    
    var count: Int {
        return array.count
    }
}
