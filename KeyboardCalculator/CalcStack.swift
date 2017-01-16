//
//  CalcStack.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/12/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

struct CalcStack {
    
    //big number divided by 6 killed it.
    //need to do the math precedence.  It's in here, but commented out.
    
    var valueArray: [Double] = []
    var operatorArray: [CalcOp] = []
    var lastEntry: Double = 0
    var lastOperater: CalcOp = (+)
    var lastOpAsString: String = ""
    
    mutating func postValueStack(_ value: Double) {
        valueArray.append(value)
    }
    
    mutating func postOperatorStack(_ op: @escaping CalcOp) {
        operatorArray.append(op)
    }
    
    mutating func popValueStack() {
        //valueArray.remove(at: valueArray.endIndex-1)
        valueArray.removeLast()
    }
    
    mutating func popOperatorStack() {
        //_ = operatorArray.remove(at: operatorArray.endIndex-1)
        _ = operatorArray.removeLast()
    }
    
}
