//
//  CalcState.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/12/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

enum CalcOp : Int {
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

enum ClearState : Int {
    case clear
    case allClear
}

class CalcState: NSObject, NSCoding {//: CustomStringConvertible {
    
    var mode: CalcMode = .entry
    var display: CalcDisplay = CalcDisplay()
    var calcStack: CalcStack = CalcStack()
    var clearState: ClearState = .allClear
    
    override init() {
        super.init()
    }
    
    var desc: String {
        switch mode {
        case .entry, .clear:
            return display.description
        case .operate, .equals, .percent:
            if let value = calcStack.valueArray.last {
                return String(format: "%g", value)
            } else {
                print("calcState.description returned 0")
                return "0"
            }
        }
    }
    
    func toMode(_ newmode: CalcMode) {
        switch (mode, newmode) {
        case (.entry, .entry):
            print("entry to entry")
        case (.entry, .operate(let op)):
            print("entry to operate")
            moveValueToStack(display.decimalValue)
            checkPrecedence()
            calcStack.pushOperatorStack(op)
        case (.operate, .operate(let op)):
            print("operate to operate")
            if !calcStack.operatorArray.isEmpty {
                calcStack.popOperatorStack()
            }
            checkPrecedence()
            calcStack.pushOperatorStack(op)  //note, this line used to be above computeDecision.  It was moved to accomodate 2+4*/ case
        case (.entry, .equals):
            print("entry to equal")
            moveValueToStack(display.decimalValue)
            //Account for case 2+=
            if calcStack.valueArray.count == 1 && calcStack.operatorArray.count == 1 {
                if let value = calcStack.lastEntry {
                    calcStack.pushValueStack(value)
                    computeDecision()
                }
            }
        case (.equals, .equals):
            print("equal to equal")
            if !calcStack.valueArray.isEmpty {
                if calcStack.lastEntry != nil, calcStack.lastOperator != nil {
                    calcStack.pushValueStack(calcStack.lastEntry!)
                    calcStack.pushOperatorStack(calcStack.lastOperator!)
                }
            }
        case (.operate, .equals):
            print("operate to equal")
            if let value = calcStack.valueArray.last {
                calcStack.pushValueStack(value)
                calcStack.lastEntry = value
            }
        case (.equals, .entry), (.percent, .entry):
            print("equal or percent to entry")
            display.reset()
            calcStack.popValueStack()
        case (.operate, .entry):
            print("operate to entry")
        case (.equals, .operate(let op)):
            print("equal to operate")
            calcStack.pushOperatorStack(op)
        case (.entry, .clear), (.percent, .clear), (.operate, .clear):
            print("entry or operate or percent to clear")
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
            calcStack.lastEntry = nil
            calcStack.lastOperator = nil
        case (.clear, .entry):
            print("clear to entry")
        case (.clear, .operate):
            print("clear to operate")
        case (.clear, .equals):
            print("clear to equal")
        case (.clear, .percent):
            print("clear to percent")
        case (.operate, .percent), (.equals, .percent):
            print("operate or equals to percent")
            calcStack.multiplyTopValue(multiplier: 0.01)
        case (.percent, .percent):
            print("percent to percent")
            calcStack.multiplyTopValue(multiplier: 0.01)
        case (.percent, .operate(let op)):
            print("percent to operate")
            checkPrecedence()
            calcStack.pushOperatorStack(op)
        case (.percent, .equals):
            print("percent to equal")
            //Account for case 2+%
            if calcStack.valueArray.count == 1 && calcStack.operatorArray.count == 1 {
                if let value = calcStack.lastEntry {
                    calcStack.pushValueStack(value)
                    computeDecision()
                }
            }
        case (.entry, .percent):
            print("entry to percent")
            let bufferEntry = calcStack.lastEntry
            moveValueToStack(display.decimalValue)
            calcStack.multiplyTopValue(multiplier: 0.01)
            if calcStack.lastOperator == .add || calcStack.lastOperator == .subtract {    //tmr - if this works, need to protect it
                calcStack.multiplyTopValue(multiplier: bufferEntry!)
            }
        }
        mode = newmode
    }
    
    func enterOperation(op: CalcOp) {
        calcStack.lastOperator = op
        toMode(.operate(op))
    }
    
    func enterEqual() {
        toMode(.equals)
        computeDecision()
    }
    
    func enterDigit(_ digit: UInt) {
        clearState = .clear
        toMode(.entry)
        display.appendDigit(digit)
    }
        
    func enterDecimal() {
        clearState = .clear
        toMode(.entry)
        display.fraction = true
    }
    
    func swapSign() {
        clearState = .clear
        switch mode {
        case .entry, .clear, .percent:
            display.toggleSign()
        case .equals, .operate:
            calcStack.multiplyTopValue(multiplier: -1)
        }
    }
    
    func percentage() {
        clearState = .clear
        toMode(.percent)
    }
    
    func clearDisplay() {
        display.reset()
        toMode(.clear)
    }
    
    func moveValueToStack(_ value: Double) {
        calcStack.pushValueStack(value)
        calcStack.lastEntry = value
        display.reset()
    }
    
    func checkPrecedence() {
        if let value = calcStack.operatorArray.last {
            if (value == .add || value == .subtract) && (calcStack.lastOperator == .multiply || calcStack.lastOperator == .divide) {
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
    
    func computeDecision() {
        
        if let value = calcStack.operatorArray.last {
            if (value == .add || value == .subtract) && (calcStack.lastOperator == .multiply || calcStack.lastOperator == .divide) {
                return
            }
            while calcStack.valueArray.count >= 2 {
                compute()
            }
        }
    }
    
    func compute() {
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
    
    /*
    func encode(with aCoder: NSCoder) {
        //aCoder.encode(mode.rawValue, forKey: "mode")
        aCoder.encode(clearState.rawValue, forKey: "clearState")
        
        aCoder.encode(calcStack.lastEntry, forKey: "lastEntry")
        aCoder.encode((calcStack.lastOperator?.rawValue)!, forKey: "lastOperator")
        aCoder.encode(calcStack.valueArray, forKey: "valueArray")
        //aCoder.encode(calcStack.operatorArray[0].rawValue, forKey: "operatorArray[0]")
        
        aCoder.encode(display.number, forKey: "number")
        aCoder.encode(display.exponent, forKey: "exponent")
        aCoder.encode(display.fraction, forKey: "fraction")
        aCoder.encode(display.positive, forKey: "positive")
    }
    
    required init(coder aDecoder: NSCoder) {
        //mode = aDecoder.decodeObject(forKey: "mode") as! CalcMode
        clearState = ClearState(rawValue: aDecoder.decodeInteger(forKey: "clearState"))!
        
        calcStack.lastEntry = aDecoder.decodeDouble(forKey: "lastEntry")
        calcStack.lastOperator = CalcOp(rawValue: aDecoder.decodeInteger(forKey: "lastOperator"))
        calcStack.valueArray = [aDecoder.decodeDouble(forKey: "valueArray")]
        //calcStack.operatorArray[0] = CalcOp(rawValue: aDecoder.decodeInteger(forKey: "operatorArray[0]"))!
        
        display.number = aDecoder.decodeObject(forKey: "number") as! UInt
        display.exponent = aDecoder.decodeObject(forKey: "exponent") as! UInt
        display.fraction = aDecoder.decodeBool(forKey: "fraction")
        display.positive = aDecoder.decodeBool(forKey: "positive")
        
        super.init()
    } */

}







