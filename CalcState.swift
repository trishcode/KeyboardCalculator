//
//  CalcState.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/12/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

typealias CalcOp = (Double, Double) -> Double

//tmr - use something like this for safety checks?
/*
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
} */

struct newType: CalcOp, Equatable {
    
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

enum operatorState {
    case add
    case mult
}

struct CalcState : CustomStringConvertible {
    
    var mode: CalcMode = .entry
    var display: CalcDisplay = CalcDisplay()
    var calcStack: CalcStack = CalcStack()
    var clearState: ClearState = .allClear
    //var operatorState: OperatorState = .add   //TMR - garbage
    
    var description: String {
        switch mode {
        case .entry:
            return display.description
        case .operate:
            return String(format: "%g", calcStack.valueArray.last!)  //TMR - unwrap this in the future
        case .equals:
            return String(format: "%g", calcStack.valueArray.last!)  //TMR - unwrap this in the future
        case .clear:
            return display.description
        }
    }
    
    /*
    mutating func addToMult(_ newmode: CalcOp) -> Bool {
        switch (operatorState, newmode) {
        case (.add .add):
            return false
        case (.add, .mult):
            return true
        case (.mult, .add):
            return false
        case (.mult, .mult):
            return false
        }
        operatorState = newmode
    }  */
    
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
                calcStack.postValueStack(calcStack.lastEntry)
                computeDecision()
            }
        case (.equals, .equals):
            print("equal to equal")
            if !calcStack.valueArray.isEmpty {
                //if calcStack.lastEntry != nil, calcStack.lastOperator != nil {
                    calcStack.postValueStack(calcStack.lastEntry)
                    calcStack.postOperatorStack(calcStack.lastOperater)
                //}
            }
        case (.operate, .equals):
            print("operate to equal")
            calcStack.postValueStack(calcStack.lastEntry)
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
    
    
    //Using type alias.  It's just an alias.
    
    mutating func enterOperation(op: @escaping CalcOp) {  //, string: String) {
        //if operation = "+" {   //TMR - garbage
        //
        //}
        if op == (-) {
            //this should work.  Do I need special characters?
        }
        calcStack.lastOperater = op
        //addToMult(op)             //TMR - garbage
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
            modifyStackTopValue(multiplier: -1)
        case .clear:
            display.toggleSign()
        case .operate:
            modifyStackTopValue(multiplier: -1)
        }
    }
    
    mutating func percentage() {
        clearState = .clear
        switch mode {
        case .entry:
            display.percentage()
        case .equals:
            modifyStackTopValue(multiplier: 0.01)
        case .clear:
            display.percentage()
        case .operate:
            modifyStackTopValue(multiplier: 0.01)
        }
    }
    
    mutating func modifyStackTopValue(multiplier: Double) {
        let value = calcStack.valueArray.last! * multiplier  //tmr - unwrap
        calcStack.popValueStack()
        calcStack.postValueStack(value)
    }
    
    mutating func clearDisplay() {
        display.reset()
        toMode(.clear)
    }
    
    mutating func moveValueToStack(_ value: Double) {
        calcStack.postValueStack(value)
        calcStack.lastEntry = value
        display.reset()
    }
    
    mutating func computeDecision() {
        //print("compute decision value stack count \(calcStack.valueArray.count)")
        //print("compute decision operator stack count \(calcStack.operatorArray.count)")
        
        //For operator precedence
        let plusCalcOp: CalcOp = (+)
        let minusCalcOp: CalcOp = (-)
        let multiplyCalcOp: CalcOp = (*)
        let divideCalcOp: CalcOp = (/)
        
        //if operatorArray.last == plusCalcOp || (-) {//&& currentOperatorEntry == (*) || (/) {
        let value = calcStack.operatorArray.last!  //tmr - need to unwrap
    
        
        //if value === plusCalcOp {//|| minusCalcOp && calcStack.lastEntry == multiplyCalcOp || divideCalcOp {
        //isEqual(value, plusCalcOp)
        
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
        
        /*
        //Perform the calculation and add the result to the value stack
        if let rt = rightTerm, let lt = leftTerm, let op = operatorTerm {
            let result = op(lt,rt)
            calcStack.valueArray.append(result)
        } */
        
        if let rt = rightTerm, let lt = leftTerm, let op = operatorTerm {
            switch op {
            case .add: return lt + rt
            case .subtract: return lt - rt
            case .multiply: return lt * rt
            case .divide: return lt / rt   //tmr - what about divide by zero?
        }
    }
    
    enum Operation {
        case add
        case subtract
        case multiply
        case divide
    }
    
    func Calculation(lt: Double, op: Operation, rt: Double) -> Double {
        
        switch op {
        case .add: return lt + rt
        case .subtract: return lt - rt
        case .multiply: return lt * rt
        case .divide: return lt / rt   //tmr - what about divide by zero?
        }
        
    }
    
}









