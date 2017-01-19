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
       displayLabel.text = calc.desc
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
        case .Minus: calc.enterOperation(op: .subtract); displayLabel.flash()
        case .Plus: calc.enterOperation(op: .add); displayLabel.flash()
        case .Divide: calc.enterOperation(op: .divide); displayLabel.flash()
        case .Multiply: calc.enterOperation(op: .multiply); displayLabel.flash()
        case .SwapSign: calc.swapSign(); displayLabel.flash()
        case .Percent: calc.percentage(); displayLabel.flash()
        case .Equal: calc.enterEqual(); displayLabel.flash()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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








