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
    
    mutating func postValueStack(_ value: Double) {
        valueArray.append(value)
    }
    
    mutating func postOperatorStack(_ op: CalcOp) {
        operatorArray.append(op)
    }
    
    mutating func popValueStack() {
        if valueArray.count != 0 {
            valueArray.removeLast()
        }
    }
    
    mutating func popOperatorStack() {
        if operatorArray.count != 0 {
            _ = operatorArray.removeLast()
        }
    }
    
    mutating func modifyTopValue(multiplier: Double) {
        if var value = valueArray.last {
            value = value * multiplier
            popValueStack()
            postValueStack(value)
        }
    }
    
}
