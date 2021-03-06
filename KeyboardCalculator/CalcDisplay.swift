//
//  CalcDisplay.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/10/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import Foundation

public let decimalFormatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.numberStyle = .decimal
    nf.maximumSignificantDigits = 10
    return nf
}()

public let scientificFormatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.numberStyle = .scientific
    nf.maximumSignificantDigits = 7
    return nf
}()

//Numeric entry area
struct CalcDisplay {
    var number: UInt = 0
    var exponent: UInt = 0
    var fraction = false
    var positive = true

    
    //The currently entered number as a Double
    var decimalValue: Double {
        return (positive ? +1 : -1) * Double(number) / pow(10, Double(exponent))
    }
    
    //Formatted for display
    
    var description : String {
        if decimalValue < -1000000000 || decimalValue > 1000000000 {
            if let formattedValue = scientificFormatter.string(from: NSNumber(value: decimalValue)) {
                return formattedValue
            } else {
                return "0"
            }
        } else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if fraction {       //this accounts for 2.03 case
                numberFormatter.minimumFractionDigits = Int(exponent + 1)
                if let formattedValue = numberFormatter.string(from: NSNumber(value:decimalValue)) {
                    let truncated = formattedValue.substring(to: formattedValue.index(before: formattedValue.endIndex))
                    return truncated
                } else {
                    return "0"
                }
            } else {
                if let formattedValue = numberFormatter.string(from: NSNumber(value:decimalValue)) {
                    return formattedValue
                } else {
                    return "0"
                }
            }
        }
    }
    
    mutating func removeDigit() {
        if fraction == true && exponent == 0 {  //last press was Decimal
            fraction = false
        } else {
            number /= 10
            if fraction {
                exponent -= 1
            }
        }
    }
    
    //When I type a zero after the decimal point, it doesn't display on the screen.
    mutating func appendDigit(_ digit: UInt) {
        number *= 10
        number += digit
        if fraction {
            exponent += 1
        }
    }
    
    mutating func toggleSign() {
        positive = positive ? false : true
    }
    
    /*
    mutating func percentage() {
        exponent = exponent + 2
        if exponent < 0 {
            fraction = true
        }
    } */

    mutating func reset() {
        self = CalcDisplay()
    }
}
