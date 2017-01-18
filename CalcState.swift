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
        case .operate:
            if let value = calcStack.valueArray.last {
                return String(format: "%g", value)
            } else {
                print("calcState.description.operate returned 0")
                return "0"
            }
        case .equals:
            if let value = calcStack.valueArray.last {
                return String(format: "%g", value)
            } else {
                print("calcState.description.equals returned 0")
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
            checkPrecedence()
            calcStack.postOperatorStack(op)
        case (.operate, .operate(let op)):
            print("operate to operate")
            if !calcStack.operatorArray.isEmpty {
                calcStack.popOperatorStack()
            }
            checkPrecedence()
            calcStack.postOperatorStack(op)  //note, this line used to be above computeDecision.  It was moved to accomodate 2+4*/ case
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
            if let value = calcStack.valueArray.last {
                calcStack.postValueStack(value)
                lastEntry = value
            }
        case (.equals, .entry):
            print("equal to entry")
            display.reset()
            calcStack.popValueStack()
        case (.operate, .entry):
            print("operate to entry")
        case (.equals, .operate(let op)):
            print("equal to operate")
            calcStack.postOperatorStack(op)
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
            display.reset()
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
    
    mutating func checkPrecedence() {
        if let value = calcStack.operatorArray.last {
            if (value == .add || value == .subtract) && (lastOperator == .multiply || lastOperator == .divide) {
                return
            }
            if lastOperator == .add || lastOperator == .subtract {
                while calcStack.valueArray.count >= 2 {
                    compute()
                }
            } else {
                compute()
            }
        }
    }
    
    mutating func computeDecision() {
        
        if let value = calcStack.operatorArray.last {
            if (value == .add || value == .subtract) && (lastOperator == .multiply || lastOperator == .divide) {
                return
            }
            while calcStack.valueArray.count >= 2 {
                compute()
            }
        }

        /*
        while calcStack.valueArray.count >= 2 {
            if let value = calcStack.operatorArray.last {
                if (value == .add || value == .subtract) && (lastOperator == .multiply || lastOperator == .divide) {
                    return
                } else {
                    compute()
                }
            }
        } */
        /*
        if let value = calcStack.operatorArray.last {
            if (value == .add || value == .subtract) && (lastOperator == .multiply || lastOperator == .divide) {
                return
            }
        }
        while calcStack.valueArray.count >= 2 {
            compute()
        }
        } */
    }
    
    //when do you stop and when do you go?
    //2+3*4=  //2+12    //it didn't continue cause last op = *  maybe that only matters first time around.  No, you have to keep checking.
    //2+3*4*  //14      //it kept going because it did
    //you keep going on =, you don't keep going on *.  
    
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
            print("\(leftTerm) \(operatorTerm) \(rightTerm) = \(result)")
        }
        print("compute complete \(calcStack.valueArray) \(calcStack.operatorArray)")
    }
    
}






