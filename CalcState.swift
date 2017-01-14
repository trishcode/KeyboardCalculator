//
//  CalcState.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/12/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation
    
typealias CalcOp = (Double, Double)->Double

enum CalcMode {
    case entry
    case operate(CalcOp)
    case equals
}

enum ClearState {
    case clear
    case allClear
}

struct CalcState : CustomStringConvertible {
    
    var mode: CalcMode = .entry
    var display: CalcDisplay = CalcDisplay()
    var calcStack: CalcStack = CalcStack()
    var clearState: ClearState = .allClear
    
    var description: String {
        switch mode {
        case .entry:
            return display.description
        case .operate:
            return String(format: "%g", calcStack.valueArray.last!)  //TMR - unwrap this in the future
        case .equals:
            return String(format: "%g", calcStack.valueArray.last!)  //TMR - unwrap this in the future
        }
    }
        
    mutating func toMode(_ newmode: CalcMode) {
        switch (mode, newmode) {
        case (.entry, .entry):
            print("entry to entry")
            mode = .entry
        case (.entry, .operate(let op)):
            print("entry to operate")
            moveValueToStack(display.decimalValue)
            //OPTIONAL:  If the value stack.count and op stack.count are equal and not zero, pop the last operator off the stack.  This covers the case if an operator was hit before a value.
            computeDecision()
            calcStack.postOperatorStack(op)
            mode = .operate(op)
        case (.operate, .operate(let op)):
            print("operate to operate")
            if !calcStack.operatorArray.isEmpty {
                calcStack.popOperatorStack()
            }
            calcStack.postOperatorStack(op)
            computeDecision()
            mode = .operate(op)
        case (.entry, .equals):
            print("entry to equal")
            moveValueToStack(display.decimalValue)
            //Account for case 2+=
            if calcStack.valueArray.count == 1 && calcStack.operatorArray.count == 1 {
                calcStack.postValueStack(calcStack.lastEntry)
                computeDecision()
            }
            mode = .equals
        case (.equals, .equals):
            print("equal to equal")
            if !calcStack.valueArray.isEmpty {
                //if calcStack.lastEntry != nil, calcStack.lastOperator != nil {
                    calcStack.postValueStack(calcStack.lastEntry)
                    calcStack.postOperatorStack(calcStack.lastOperater)
                //}
            }
            mode = .equals
        case (.operate, .equals):
            print("operate to equal")
            calcStack.postValueStack(calcStack.lastEntry)
            mode = .equals
        case (.equals, .entry):
            print("equal to entry")
            clearState = .allClear
            mode = .entry
        case (.operate, .entry):
            print("operate to entry")
            mode = .entry
            return
        case (.equals, .operate(let op)):
            print("equal to operate")
            //not sure what this should do
            mode = .operate(op)
            return
        }
    }
    
    //.entry -> .clear -->  don't pop the value stack
    //.equal -> .clear -->  pop the value stack
    //.clear -> .clear -->  allClear
    
    mutating func enterOperation(op: @escaping CalcOp, value: Double? = nil) {
        calcStack.lastOperater = op
        
        if let value = value {      //tmr - this part handles the +/- and %
            //toMode(.result(op))
            //calc.push(op, value: value)
        } else {
            //toMode(.result(op))
            toMode(.operate(op))
        }
    }
    
    mutating func equalsButtonPressed() {
        toMode(.equals)
        computeDecision()
    }
    
    mutating func enterDigit(_ digit: UInt) {
        clearState = .clear
        toMode(.entry)
        display.appendDigit(digit)
    }
        
    mutating func enterDecimal() {
        clearState = .clear
        toMode(.entry)
        display.fraction = true
    }
    
    mutating func clearDisplay() {
        display.reset()
        switch clearState {
        case .clear:
            //calcStack.popValueStack()
            clearState = .allClear
            mode = .entry
            print("clear ran")
        case .allClear:
            calcStack = CalcStack()
            print("all clear ran")
        }
    }
    
    mutating func moveValueToStack(_ value: Double) {
        calcStack.postValueStack(value)
        calcStack.lastEntry = value
        display.reset()
    }
    
    mutating func computeDecision() {
        //print("compute decision value stack count \(calcStack.valueArray.count)")
        //print("compute decision operator stack count \(calcStack.operatorArray.count)")
        
        //if operatorArray.last == (+) || (-) && currentOperatorEntry == (*) || (/) {
        //    return
        //}
        while calcStack.valueArray.count >= 2 {
            compute()
        }
    }
    
    mutating func compute() {
        //Load the operands and operators and update the stacks
        let rightTerm = calcStack.valueArray.last
        calcStack.popValueStack()
        let leftTerm = calcStack.valueArray.last
        calcStack.popValueStack()
        let operatorTerm = calcStack.operatorArray.last
        calcStack.popOperatorStack()
        
        //Perform the calculation and add the result to the value stack
        if let rt = rightTerm, let lt = leftTerm, let op = operatorTerm {
            let result = op(lt,rt)
            calcStack.valueArray.append(result)
        }
    }
    
} 









