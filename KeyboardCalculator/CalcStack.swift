//
//  CalcStack.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/12/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

struct CalcStack {
    
    var valueArray: [Double] = []
    var operatorArray: [CalcOp] = []
    var lastEntry: Double = 0
    var lastOperater: CalcOp = (+)
    
    mutating func postValueStack(_ value: Double) {
        valueArray.append(value)
    }
    
    mutating func postOperatorStack(_ op: @escaping CalcOp) {
        operatorArray.append(op)
    }
    
    mutating func popValueStack() {
        valueArray.remove(at: valueArray.endIndex-1)
    }
    
    mutating func popOperatorStack() {
        _ = operatorArray.remove(at: operatorArray.endIndex-1)
    }
    
}
