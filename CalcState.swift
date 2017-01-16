//
//  CalcState.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/12/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

enum CalcOp {
    case add
    case subtract
    case multiply
    case divide
}

enum CalcMode {
    case entry
    case operate(CalcOp)
    case equals
    case clear
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
    
    var lastEntry: Double?
    var lastOperator: CalcOp?
    
    var description: String {
        switch mode {
        case .entry:
            return display.description
        case .operate:   //tmr - put the below statements into a function after you've stopped crashing
            if let value = calcStack.valueArray.last {
                return String(format: "%g", value)
            } else {
                print("calcState.description.operate failed")
                return "0"
            }
        case .equals:
            if let value = calcStack.valueArray.last {
                return String(format: "%g", value)
            } else {
                print("calcState.description.equals failed")
                return "0"
            }
        case .clear:
            return display.description
        }
    }
    
    mutating func toMode(_ newmode: CalcMode) {
        switch (mode, newmode) {
        case (.entry, .entry):
            print("entry to entry")
        case (.entry, .operate(let op)):
            print("entry to operate")
            moveValueToStack(display.decimalValue)
            //OPTIONAL:  If the value stack.count and op stack.count are equal and not zero, pop the last operator off the stack.  This covers the case if an operator was hit before a value.
            computeDecision()
            calcStack.postOperatorStack(op)
        case (.operate, .operate(let op)):
            print("operate to operate")
            if !calcStack.operatorArray.isEmpty {
                calcStack.popOperatorStack()
            }
            calcStack.postOperatorStack(op)
            computeDecision()
        case (.entry, .equals):
            print("entry to equal")
            moveValueToStack(display.decimalValue)
            //Account for case 2+=
            if calcStack.valueArray.count == 1 && calcStack.operatorArray.count == 1 {
                if let value = lastEntry {
                    calcStack.postValueStack(value)
                    computeDecision()
                }
            }
        case (.equals, .equals):
            print("equal to equal")
            if !calcStack.valueArray.isEmpty {
                if lastEntry != nil, lastOperator != nil {
                    calcStack.postValueStack(lastEntry!)
                    calcStack.postOperatorStack(lastOperator!)
                }
            }
        case (.operate, .equals):
            print("operate to equal")
            if let value = lastEntry {
                calcStack.postValueStack(value)
            }
        case (.equals, .entry):
            print("equal to entry")
            display.reset()
            calcStack.popValueStack()
        case (.operate, .entry):
            print("operate to entry")
        case (.equals, .operate):
            print("equal to operate")
            //not sure what this should do
        case (.entry, .clear):
            print("entry to clear")
            display.reset()
            clearState = .allClear
        case (.operate, .clear):
            print("operate to clear")
            display.reset()
            clearState = .allClear
        case (.equals, .clear):
            print("equal to clear")
            display.reset()
            calcStack.popValueStack()
            clearState = .allClear
        case (.clear, .clear):
            print("clear to clear")
            display.reset()
            calcStack = CalcStack()
        case (.clear, .entry):
            print("clear to entry")
        case (.clear, .operate):
            print("clear to operate")
        case (.clear, .equals):
            print("clear to equal")
        }
        mode = newmode
    }
    
    
    mutating func enterOperation(op: CalcOp) {
        lastOperator = op
        toMode(.operate(op))
    }
    
    mutating func enterEqual() {
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
    
    mutating func swapSign() {
        clearState = .clear
        switch mode {
        case .entry:
            display.toggleSign()
        case .equals:
            calcStack.modifyTopValue(multiplier: -1)
        case .clear:
            display.toggleSign()
        case .operate:
            calcStack.modifyTopValue(multiplier: -1)
        }
    }
    
    mutating func percentage() {
        clearState = .clear
        switch mode {
        case .entry:
            display.percentage()
        case .equals:
            calcStack.modifyTopValue(multiplier: 0.01)
        case .clear:
            display.percentage()
        case .operate:
            calcStack.modifyTopValue(multiplier: 0.01)
        }
    }
    
    mutating func clearDisplay() {
        display.reset()
        toMode(.clear)
    }
    
    mutating func moveValueToStack(_ value: Double) {
        calcStack.postValueStack(value)
        lastEntry = value
        display.reset()
    }
    
    mutating func computeDecision() {
        //print("compute decision value stack count \(calcStack.valueArray.count)")
        //print("compute decision operator stack count \(calcStack.operatorArray.count)")
        
        if let value = calcStack.operatorArray.last {
            if (value == .add || value == .subtract) && (lastOperator == .multiply || lastOperator == .divide) {
                return
            }
        }
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
        let result: Double
        
        if let rt = rightTerm, let lt = leftTerm, let op = operatorTerm {
            switch op {
            case .add: result = lt + rt
            case .subtract: result = lt - rt
            case .multiply: result = lt * rt
            case .divide: result = lt / rt
            }
            calcStack.valueArray.append(result)
        }
    }
    
}







