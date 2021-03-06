//
//  CalcButton.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/10/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//


import UIKit

enum CalcButtonType : String {
    case Plus = "+"
    case Minus = "-"
    case Divide = "÷"
    case Multiply = "x"
    case Equal = "="
    case Decimal = "."
    case SwapSign = "±"
    case Percent = "%"
    case Num0 = "0"
    case Num1 = "1"
    case Num2 = "2"
    case Num3 = "3"
    case Num4 = "4"
    case Num5 = "5"
    case Num6 = "6"
    case Num7 = "7"
    case Num8 = "8"
    case Num9 = "9"
    case Clear = "AC"
    case Back = "←"
}

class CalcButton: UIButton {
    
    //Declare the normal and highlighted background color variables
    var normalBGC = UIColor()
    var highlightedBGC = UIColor()

    //Required initialization for button instances created from the storyboard
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let name: String = self.title(for: .normal)!
        let type = CalcButtonType(rawValue: name)!
        
        //Set the button style
        layer.cornerRadius = 16
        
        //Set the appropriate button attributes based on the kind of button
        switch type {
        case .Plus, .Multiply, .Minus, .Divide:
            normalBGC = UIColor(red: 195/255, green: 49/255, blue: 85/255, alpha: 1)
            highlightedBGC = UIColor(red: 195/255, green: 128/255, blue: 128/255, alpha: 1)
            //setTitleColor(UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1), for: .highlighted)
        case .Equal:
            normalBGC = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
            highlightedBGC = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        case .Num0, .Num1, .Num2, .Num3, .Num4, .Num5, .Num6, .Num7, .Num8, .Num9, .Decimal, .Percent, .SwapSign, .Back:
            normalBGC = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
            highlightedBGC = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        default:    //clear button
            normalBGC = UIColor(red: 195/255, green: 49/255, blue: 85/255, alpha: 1)
            highlightedBGC = UIColor(red: 195/255, green: 128/255, blue: 128/255, alpha: 1)
        }
        backgroundColor = normalBGC
    }
    
    //When a button is pressed from the UI, change the background color to the highlighted color for a time delay, and then change back to the normal color.
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedBGC
            } else {
                backgroundColor = normalBGC
            }
        }
    }
    
    //When a key is pressed from the keyboard, change the background color to the highlighted color for a time delay, and then change back to the normal color.
    func pressAnimation() {
        backgroundColor = highlightedBGC
        UIView.animate(withDuration: 0.2, animations: {self.backgroundColor = self.normalBGC})
    }

}
