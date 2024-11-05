//
//  Double.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

extension Double {
    func toInt() -> Int {
        Int(self)
    }
    
    var stringFormatted: String {
        // If number doesn't have decimal values, consider only the integer part
        String(format: "%.\(self.decimalPlaces)f", self)
    }
    
    private var decimalPlaces: Int {
        guard self.truncatingRemainder(dividingBy: 1) != 0 else { return 0 }
        let numberString = String(self)
        guard let decimalRange = numberString.range(of: ".") else { return 0 }
        let decimalPartCount = numberString[decimalRange.upperBound...].count
        // If number has only 1 decimal value, return anyway 2 values
        return decimalPartCount == 1 ? 2 : decimalPartCount
    }
}
