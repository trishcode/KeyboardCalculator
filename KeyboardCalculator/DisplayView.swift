//
//  DisplayView.swift
//  KeyboardCalculator
//
//  Created by Tricia Rudloff on 1/13/17.
//  Copyright © 2017 TrishCode. All rights reserved.
//

import UIKit

class DisplayView: UILabel {
    
    //The flash method "flashes" the UILabel by making it transparent for a short delay.
    func flash() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.1, animations: {self.alpha = 1.0})
    }
    
}
