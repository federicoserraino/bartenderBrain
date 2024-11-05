//
//  DailyNotification.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 04/11/24.
//

import Foundation

enum DailyNotification: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var weekDay: Int {
        self.rawValue
    }
    
    var defaultHour: Int {
        12 // Send daily notification at 12 PM
    }
    
    var identifier: String {
        "DailyReminderIdentifier_\(weekDay)"
    }
    
    
}
