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
    
    mutating func pushValueStack(_ value: Double) {
        valueArray.append(value)
        print("post Val \(valueArray)")
    }
    
    mutating func pushOperatorStack(_ op: CalcOp) {
        operatorArray.append(op)
        print("post Op \(operatorArray)")
    }
    
    mutating func popValueStack() {
        if valueArray.count != 0 {
            valueArray.removeLast()
            print("pop Val \(valueArray)")
        }
    }
    
    mutating func popOperatorStack() {
        if operatorArray.count != 0 {
            _ = operatorArray.removeLast()
            print("pop Op \(operatorArray)")
        }
    }
    
    mutating func multiplyTopValue(multiplier: Double) {
        if var value = valueArray.last {
            value = value * multiplier
            popValueStack()
            pushValueStack(value)
        }
    }
    
}
