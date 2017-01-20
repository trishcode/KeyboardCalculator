//
//  CalcStack.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/12/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

//Handles the entry and operator arrays
struct CalcStack {
    
    var valueArray: [Double] = []
    var operatorArray: [CalcOp] = []
    
    var lastEntry: Double?
    var lastOperator: CalcOp?
    
    mutating func pushValueStack(_ value: Double) {
        valueArray.append(value)
    }
    
    mutating func pushOperatorStack(_ op: CalcOp) {
        operatorArray.append(op)
    }
    
    mutating func popValueStack() {
        if !valueArray.isEmpty {
            valueArray.removeLast()
        }
    }
    
    mutating func popOperatorStack() {
        if !operatorArray.isEmpty {
            _ = operatorArray.removeLast()
        }
    }
    
    mutating func multiplyTopValue(multiplier: Double) {
        if var value = valueArray.last {
            value = value * multiplier
            popValueStack()
            pushValueStack(value)
            lastEntry = value
        }
    }
    
}
