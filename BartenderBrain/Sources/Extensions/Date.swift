//
//  Date.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 04/11/24.
//

import Foundation

extension Date {
    var weekday: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday
    }
    
    var hour: Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        return hour
    }
}
