//
//  Calc.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/10/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

//Need to better understand how your data types interact with each other.  They need to be their own little modules doing independent work.  Can't x-ref between them all by creating references between all the types.  Should calcMode be it's own type?  If so, what creates an instance of this?  Go through the data types in the git program to understand how they interact with each other.

import Foundation

enum CalcMode {
    case entry
    case operation
    case result
    case clear
}

enum ClearState {
    case clear
    case allClear
}

typealias CalcOp = (Double, Double) -> Double

struct Calc {
    
    var display: CalcDisplay = CalcDisplay()
    var suffix = ""
    var calcMode: CalcMode = .entry
    var clearState: ClearState = .allClear
    
    var valueArray: [Double] = []
    var operatorArray: [CalcOp] = []
    
    var lastValueEntry: Double?
    var lastOperatorEntry: CalcOp?
    
    //need something like this to handle different displays
    /*
    var description: String {
        switch calcMode {
        case .entry:
            return display.description
        case .result(let op):
            return
            return String(format: "%g%@", calc.run(), suffix)
        }
    } */
    
    /*this is just an idea is you want to perform an action when something updates.
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }  */
    
    var currentValueEntry: Double? {
        didSet {
            lastValueEntry = oldValue
            //should I be doing this the other way, like updating something when the value changes?
        }
    }
    
    var currentOperatorEntry: CalcOp? {
        didSet {
            lastOperatorEntry = oldValue
        }
    }
    
    mutating func compute() {
        //Load the operands and operators and update the stacks
        let rightTerm = valueArray.last
        popValueStack()
        let leftTerm = valueArray.last
        popValueStack()
        let operatorTerm = operatorArray.last
        popOperatorStack()
        
        //Perform the calculation and add the result to the value stack
        if let rt = rightTerm, let lt = leftTerm, let op = operatorTerm {
            let result = op(lt,rt)
            valueArray.append(result)
        }
    }
    
    mutating func moveCurrentValueToStack() {
        if let currentValue = currentValueEntry {
            print("moved current value \(currentValue)")
            postValueStack(currentValue)
            currentValueEntry = nil
        }
    }
    
    mutating func postValueStack(_ value: Double) {
        valueArray.append(value)
    }
    
    mutating func postOperatorStack(_ op: @escaping CalcOp) {
        operatorArray.append(op)
    }
    
    mutating func popValueStack() {
        valueArray.remove(at: valueArray.endIndex)
    }
    
    mutating func popOperatorStack() {
        _ = operatorArray.remove(at: operatorArray.endIndex)
    }
    
    mutating func clearStacks() {
        valueArray.removeAll()
        operatorArray.removeAll()
        currentValueEntry = nil
        currentOperatorEntry = nil
        lastValueEntry = nil
        lastOperatorEntry = nil
    }
    
    mutating func enterDigit(_ digit: UInt) {
        //toMode(.entry)
        display.appendDigit(digit)
    }
    
    mutating func enterOperation(op: @escaping CalcOp, value: Double? = nil, suffix: String = "") {
        self.suffix = suffix
        currentOperatorEntry = op
        display.reset()
        
        if calcMode == .operation {        //this means that two operators in a row?
            if !operatorArray.isEmpty {
                popOperatorStack()
            }
            postOperatorStack(op)
            computeDecision()
        } else {
            calcMode = .operation
            moveCurrentValueToStack()
            //OPTIONAL:  If the value stack.count and op stack.count are equal and not zero, pop the last operator off the stack.  This covers the case if an operator was hit before a value.
            computeDecision()
            postOperatorStack(op)
        }
        
        /*
        if let value = value {
            toMode(.result(op))
            calc.push(op, value: value)
        } else {
            toMode(.result(op))
        } */
    }
    
    mutating func enterDecimal() {
        //toMode(.entry)
        display.fraction = true
    }
    
    //This is the decision to compute.  Not sure where it goes.
    mutating func computeDecision() {
        //if operatorArray.last == (+) || (-) && currentOperatorEntry == (*) || (/) {
        //    return
        //}
        while valueArray.count >= 2 {
            compute()
        }
    }
    
    mutating func equalButtonPress() {
        if calcMode == .result {               //this means the last button hit was equals?
            if !valueArray.isEmpty {
                if lastValueEntry != nil, lastOperatorEntry != nil {
                    postValueStack(lastValueEntry!)
                    postOperatorStack(lastOperatorEntry!)
                    computeDecision()
                }
            }
        } else {
            calcMode = .result
            moveCurrentValueToStack()
            
            //Account for case 2+=
            if valueArray.count == 1 && operatorArray.count == 1 {
                if lastValueEntry != nil {
                    postValueStack(lastValueEntry!)
                    computeDecision()
                }
            }
        }
    }
    
    mutating func clearButtonPress() {
        display.reset()
        if clearState == .clear {
            popValueStack()
            clearState = .allClear
        } else if clearState == .allClear {
            calcMode = .clear   // or clearStacks()
        }
    }
    
}
