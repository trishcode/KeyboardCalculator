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
    case percent
}

enum ClearState {
    case clear
    case allClear
}

struct CalcState {
    
    var mode: CalcMode = .entry
    var display: CalcDisplay = CalcDisplay()
    var calcStack: CalcStack = CalcStack()
    var clearState: ClearState = .allClear
    
    //Conditioning and formatting for the display
    var desc: String {
        switch mode {
        case .entry, .clear:
            return display.description
        case .operate, .equals, .percent:
            if let lastValue = calcStack.valueArray.last {
                if lastValue < 1000000000 && lastValue > -1000000000 {
                    return formatValue(value: lastValue, formatType: decimalFormatter)
                } else {
                    return formatValue(value: lastValue, formatType: scientificFormatter)
                }
            } else {
                return "0"
            }
        }
    }
    
    func formatValue(value: Double, formatType: NumberFormatter) -> String {
        if let formattedValue = formatType.string(from:NSNumber(value: value)) {
            return formattedValue
        } else {
            return "0"
        }
    }
    
    mutating func toMode(_ newmode: CalcMode) {
        switch (mode, newmode) {
        case (.entry, .operate(let op)):
            moveValueToStack(display.decimalValue)
            operatorComputeDecision()
            calcStack.pushOperatorStack(op)
        case (.operate, .operate(let op)):
            calcStack.popOperatorStack()
            operatorComputeDecision()
            calcStack.pushOperatorStack(op)
        case (.entry, .equals):
            moveValueToStack(display.decimalValue)
            pushCurrentValue()
        case (.equals, .equals):
            if !calcStack.valueArray.isEmpty {
                if calcStack.lastEntry != nil, calcStack.lastOperator != nil {
                    calcStack.pushValueStack(calcStack.lastEntry!)
                    calcStack.pushOperatorStack(calcStack.lastOperator!)
                }
            }
        case (.operate, .equals):
            if let value = calcStack.valueArray.last {
                calcStack.pushValueStack(value)
                calcStack.lastEntry = value
            }
        case (.equals, .entry), (.percent, .entry):
            display.reset()
            calcStack.popValueStack()
        case (.equals, .operate(let op)):
            calcStack.pushOperatorStack(op)
        case (.entry, .clear), (.percent, .clear), (.operate, .clear):
            display.reset()
            clearState = .allClear
        case (.equals, .clear):
            display.reset()
            calcStack.popValueStack()
            clearState = .allClear
        case (.clear, .clear):
            display.reset()
            calcStack = CalcStack()
            calcStack.lastEntry = nil
            calcStack.lastOperator = nil
        case (.operate, .percent), (.equals, .percent):
            calcStack.multiplyTopValue(multiplier: 0.01)
        case (.percent, .percent):
            calcStack.multiplyTopValue(multiplier: 0.01)
        case (.percent, .operate(let op)):
            operatorComputeDecision()
            calcStack.pushOperatorStack(op)
        case (.percent, .equals):
            pushCurrentValue()
        case (.entry, .percent):
            let bufferEntry = calcStack.lastEntry
            moveValueToStack(display.decimalValue)
            calcStack.multiplyTopValue(multiplier: 0.01)
            addPercentCalc(addValue: bufferEntry)
        default:
            mode = newmode
            return
        }
        mode = newmode
    }
    
    mutating func enterOperation(op: CalcOp) {
        calcStack.lastOperator = op
        toMode(.operate(op))
    }
    
    mutating func enterEqual() {
        toMode(.equals)
        equalsComputeDecision()
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
    
    mutating func enterBackSign() {
        toMode(.entry)
        display.removeDigit()
    }
    
    mutating func swapSign() {
        clearState = .clear
        switch mode {
        case .entry, .clear:
            display.toggleSign()
        case .equals, .operate, .percent:
            calcStack.multiplyTopValue(multiplier: -1)
        }
    }
    
    mutating func percentage() {
        clearState = .clear
        toMode(.percent)
    }
    
    mutating func clearDisplay() {
        display.reset()
        toMode(.clear)
    }
    
    mutating func moveValueToStack(_ value: Double) {
        calcStack.pushValueStack(value)
        calcStack.lastEntry = value
        display.reset()
    }
    
    //Push current value onto value stack. Accounts for cases 2+% and 2+=
    mutating func pushCurrentValue() {
        if calcStack.valueArray.count == 1 && calcStack.operatorArray.count == 1 {
            if let lastValue = calcStack.lastEntry {
                calcStack.pushValueStack(lastValue)
                equalsComputeDecision()
            }
        }
    }
    
    mutating func operatorComputeDecision() {
        if let lastArrayOp = calcStack.operatorArray.last {
            if (lastArrayOp == .add || lastArrayOp == .subtract) && (calcStack.lastOperator == .multiply || calcStack.lastOperator == .divide) {
                return
            }
            if calcStack.lastOperator == .add || calcStack.lastOperator == .subtract {
                while calcStack.valueArray.count >= 2 {
                    compute()
                }
            } else {
                compute()
            }
        }
    }
    
    mutating func equalsComputeDecision() {
        if let lastArrayOp = calcStack.operatorArray.last {
            if (lastArrayOp == .add || lastArrayOp == .subtract) && (calcStack.lastOperator == .multiply || calcStack.lastOperator == .divide) {
                return
            }
            while calcStack.valueArray.count >= 2 {
                compute()
            }
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
            //print("\(leftTerm) \(operatorTerm) \(rightTerm) = \(result)")
        }
    }
    
    mutating func addPercentCalc(addValue: Double?) {
        if calcStack.lastOperator == .add || calcStack.lastOperator == .subtract {
            if addValue != nil {
                calcStack.multiplyTopValue(multiplier: addValue!)
            }
        }
    }
    
}







