//
//  Double+Extensions.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 24/05/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import Foundation

extension Double {
    
    var zeroDecimals: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self))!
    }
    
    var twoDigits: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self))!
    }
    
}
