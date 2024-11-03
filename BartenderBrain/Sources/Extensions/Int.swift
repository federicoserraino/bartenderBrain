//
//  Int.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

extension Int {
    var timeFormatFromSeconds: String {
        let min = self / 60
        let resSec = self % 60
        return String(format: "%02d:%02d", min, resSec)
    }
    
    func toDouble() -> Double {
        Double(self)
    }
}
