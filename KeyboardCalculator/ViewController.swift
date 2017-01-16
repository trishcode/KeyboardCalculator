//
//  ViewController.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/10/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calc = CalcState()
    var keyCommandArray = [UIKeyCommand]()
    var keyPressArray = [keyPress]()

    //Display label outlet
    @IBOutlet var displayLabel: DisplayView!
    
    func updateClearButtonTitle() {
        var title: String {
            switch calc.clearState {
            case .clear:
                return "C"
            case .allClear:
                return "AC"
            }
        }
        clearButton.setTitle(title, for: .normal)
    }

    func updateDisplayLabel() {
       displayLabel.text = calc.description
    }
    
    //UI button outlets
    @IBOutlet var oneButton: CalcButton!
    @IBOutlet var twoButton: CalcButton!
    @IBOutlet var threeButton: CalcButton!
    @IBOutlet var fourButton: CalcButton!
    @IBOutlet var fiveButton: CalcButton!
    @IBOutlet var sixButton: CalcButton!
    @IBOutlet var sevenButton: CalcButton!
    @IBOutlet var eightButton: CalcButton!
    @IBOutlet var nineButton: CalcButton!
    @IBOutlet var zeroButton: CalcButton!
    @IBOutlet var decimalButton: CalcButton!
    @IBOutlet var plusButton: CalcButton!
    @IBOutlet var minusButton: CalcButton!
    @IBOutlet var multiplyButton: CalcButton!
    @IBOutlet var divideButton: CalcButton!
    @IBOutlet var equalButton: CalcButton!
    @IBOutlet var clearButton: CalcButton!
    @IBOutlet var percentageButton: CalcButton!
    @IBOutlet var signButton: CalcButton!
    
    
    @IBAction func press(_ button: CalcButton) {
        
        let name = button.title(for: .normal)!
        let type = CalcButtonType(rawValue: name)!
        
        switch type {
        case .Num0: calc.enterDigit(0)
        case .Num1: calc.enterDigit(1)
        case .Num2: calc.enterDigit(2)
        case .Num3: calc.enterDigit(3)
        case .Num4: calc.enterDigit(4)
        case .Num5: calc.enterDigit(5)
        case .Num6: calc.enterDigit(6)
        case .Num7: calc.enterDigit(7)
        case .Num8: calc.enterDigit(8)
        case .Num9: calc.enterDigit(9)
        case .Minus: calc.enterOperation(op: -); displayLabel.flash()
        case .Plus: calc.enterOperation(op: +); displayLabel.flash()
        case .Divide: calc.enterOperation(op: /); displayLabel.flash()
        case .Multiply: calc.enterOperation(op: *); displayLabel.flash()
        case .SwapSign: calc.swapSign(); displayLabel.flash()
        case .Percent: calc.percentage()
        case .Equal: calc.enterEqual()
        case .Decimal: calc.enterDecimal()
        default: return
        }

        updateDisplayLabel()
        updateClearButtonTitle()
    }
    
    @IBAction func clearButtonPress(_ sender: CalcButton) {
        calc.clearDisplay()
        updateDisplayLabel()
        updateClearButtonTitle()
    }
    
    struct Test {
        var calc: (Double, Double) -> Double
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var test: Test = (+)

        
        //Load array for keyboard commands.
        keyPressArray = [
            keyPress(input: "1", title: "number 1", button: oneButton),
            keyPress(input: "2", title: "number 2", button: twoButton),
            keyPress(input: "3", title: "number 3", button: threeButton),
            keyPress(input: "4", title: "number 4", button: fourButton),
            keyPress(input: "5", title: "number 5", button: fiveButton),
            keyPress(input: "6", title: "number 6", button: sixButton),
            keyPress(input: "7", title: "number 7", button: sevenButton),
            keyPress(input: "8", title: "number 8", button: eightButton),
            keyPress(input: "9", title: "number 9", button: nineButton),
            keyPress(input: "0", title: "number 0", button: zeroButton),
            keyPress(input: "+", title: "plus sign", button: plusButton),
            keyPress(input: "-", title: "minus sign", button: minusButton),
            keyPress(input: "*", title: "multiplication sign", button: multiplyButton),
            keyPress(input: "/", title: "division sign", button: divideButton),
            keyPress(input: "=", title: "equals", button: equalButton),
            keyPress(input: "\r", title: "equals", button: equalButton),
            keyPress(input: "C", title: "clear", button: clearButton),
            keyPress(input: UIKeyInputEscape, title: "clear", button: clearButton),
            keyPress(input: "%", title: "percentage sign", button: percentageButton),
            keyPress(input: ".", title: "decimal point", button: decimalButton)
        ]
        
        //Load UIKeyCommand array
        for key in keyPressArray {
            keyCommandArray.append(UIKeyCommand(input: key.input, modifierFlags: [], action: #selector(UIKeyReplication), discoverabilityTitle: key.title))
        }
    }
    
    //Override the view controller key commands to detect keyboard presses
    override var keyCommands: [UIKeyCommand]? {
        return keyCommandArray
    }
    
    //The following function replicates key presses from the UI from the keyboard
    func UIKeyReplication(sender: UIKeyCommand) {
        //Find the key that matches .input in the array, and get the corresponding .button.
        for i in 0 ... (keyPressArray.count-1) {
            if sender.input == keyPressArray[i].input {
                let button = keyPressArray[i].button
                button.sendActions(for: .touchUpInside)
                
                //Animate the button when the key is pressed
                let thisButton = button as! CalcButton
                thisButton.pressAnimation()
            }
        }
    }
    
}





//TMR - what's up with the mutating and escaping?

//COMPUTE
//If the last operator in the stack is + or - and the current operator is * or /, do not compute.
//If there are at least two values on the stack, compute.  Repeat.

//rt = valueArray.last
//valueArray.removeLast

//lt = valueArray.last
//valueArray.removeLast

//op = opArray.last
//opArry.removeLast

//result = op(lt,rt)
//valueArray.add = result


//When I hit a number  (Set an Entry mode?) - might help to do things during modes or transitions of modes
//If the value stack is empty, create a calc instance (is this necessary?  maybe just do the next step.)
//If calc.currentEntry is empty put the number in it
//If there is a calc.current entry, append it
//If the last button pressed was =, clear the stacks and dispose of calc instance. (Because the stack is empty, a calc instance is created.)

//If an operator is hit   (Set a Calc mode?)
//If the last button was an operator (already in Calc mode?), then pop the last value off the operator stack, and put this one on.  Compute if you can.
//If the last button was not an operator:
//If not empty, move the calc.currentEntry to the value stack, and clear the calc.currentEntry
//OPTIONAL:  If the value stack.count and op stack.count are equal and not zero, pop the last operator off the stack.  This covers the case if an operator was hit before a value.
//Compute if you can.
//Add this operator to the stack.

//When equal is hit  (Set a Result mode?)
//If the last button pressed was not equals
//If not empty, move the calc.currentEntry to the value stack, and clear the calc.currentEntry
//If there is exactly one value in the operator stack and exactly one in the value stack, move the last value entry to the value stack.
//Compute if you can.
//If the last button pressed was equals
//If the value stack is not empty, move the last value entry to the value stack and the last operator to the operator stack.
//Compute

//Hitting the clear button
//Hitting the clear button when it says "C" pops the last value off of the stack, and changes the button display from "C" to "AC"
//Hitting the clear button when it says "AC" destroys the calc instance.
//when a calc instance is created, the clear button changes from "AC" to "C"

//Display
//Shows the current entry if there is one.  If there is not a current entry, show the top value of the stack.

//+/- and %
//If there is a current value, apply to the current value.  Need to do this as seperate functions, and then return the current value to itself.
//If there is not a current value, need to apply to the top stack value.  Need to do this as seperate functions, and then return the value to itself.






//3     create calc instance.  Set current entry to this value.
//4     append to current entry
//+     Put current entry on value stack.  Compute if you can.  Put this entry operator stack.
//-     Two ops in a row, pop last value off operator stack.  Put this value on operator stack.
//4     Set to current entry
//=     Put current entry on value stack.  Compute.  (Perform computation with operator precedence until operator stack is empty.  Value in the value stack is your result.)

//If I hit equal again, I think I move the last entry into the value stack, and put the last operator on the operator stack, and perform the computation. I have to know the last operator and last entry.  Maybe I can do these with operator observers.  If I hit equal, and there's no value in the operator stack, do above.
//If I type another number after equals, I need to clear my stacks.
//If I hit an operator after equals, I put that operator in the operator stack.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this entry operator stack.
//=     How do I execute the stack in this case?  If I have an operator and only one item on the value stack, I add the last stack value to the end of the stack, and I compute.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.
//3     Set to current entry
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!
//*     Two ops in a row, pop last value off operator stack.  Put this value on operator stack.
//7     Set to current entry
//+     {Answer is 23.}  Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.
//3     Set to current entry
//*     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!
//4     Set to current entry
//=     {Answer is 13.}  Put current entry on value stack.  Compute.

//2     create calc instance.  Set current entry to this value.
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack.
//3     Set to current entry
//*     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!
//4     Set to current entry
//+     Put current entry on value stack.  Compute if you can.  Put this operator on the operator stack after the compute is done!




//Test cases.
//=*
//2=*
//2+=*
//2+==*
//2+3=*
//2+3==*
//2+=*=

//Cases for OPTIONAL operator case.
//+3+     //3
//+3==    //6
//+3+6=   //9

//Modes, 2.0

//When I hit a number, set entry mode.
//Run append digit, which updated .decVal
//If the last button pressed was =, clear the stacks (if not in calc struct) and create new calc instance (to clear)

//If an operator is hit, set operator mode.
//If the last button was an operator (already in Calc mode?), then pop the last value off the operator stack, and put this one on.  Compute if you can.
//If the last button was not an operator:
//If not empty, move the calc.currentEntry to the value stack, and clear the calc.currentEntry
//OPTIONAL:  If the value stack.count and op stack.count are equal and not zero, pop the last operator off the stack.  This covers the case if an operator was hit before a value.
//Compute if you can.
//Add this operator to the stack.

//When equal is hit  (Set a Result mode?)
//If the last button pressed was not equals
//If not empty, move the calc.currentEntry to the value stack, and clear the calc.currentEntry
//If there is exactly one value in the operator stack and exactly one in the value stack, move the last value entry to the value stack.
//Compute if you can.
//If the last button pressed was equals
//If the value stack is not empty, move the last value entry to the value stack and the last operator to the operator stack.
//Compute

//Hitting the clear button
//Hitting the clear button when it says "C" pops the last value off of the stack, and changes the button display from "C" to "AC"
//Hitting the clear button when it says "AC" destroys the calc instance.
//when a calc instance is created, the clear button changes from "AC" to "C"
