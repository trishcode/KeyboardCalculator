//
//  CalcDisplay.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/10/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

/// A numeric entry area that handles partially-entered numbers such as "-0."
struct CalcDisplay : CustomStringConvertible {
    var number: UInt = 0
    var exponent: UInt = 0
    var fraction = false
    var positive = true
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    /// The currently entered number as a Double
    var decimalValue: Double {
        return (positive ? +1 : -1) * Double(number) / pow(10, Double(exponent))
    }
    
    var description : String {
        if fraction {
            let desc = String(format: "%.\(exponent+1)f", self.decimalValue)
            return String(desc.characters.dropLast())  //TMR - antiquated
        } else {
            return String(format: "%g", self.decimalValue)
        }
    }
    
    mutating func appendDigit(_ digit: UInt) {
        number *= 10
        number += digit
        if fraction {
            exponent += 1
        }
    }
    
    mutating func reset() {
        self = CalcDisplay()
    }
}



/*
 let numberFormatter: NumberFormatter = {
 let nf = NumberFormatter()
 nf.numberStyle = .decimal
 nf.minimumFractionDigits = 0
 nf.maximumFractionDigits = 1
 return nf
 }()
 
 celsiusLabel.text = numberFormatter.string(for: value)
 */
