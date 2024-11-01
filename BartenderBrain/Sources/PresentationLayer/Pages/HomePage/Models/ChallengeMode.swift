//
//  ChallengeMode.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

enum ChallengeMode {
    case beginner
    case intermediate
    case advanced
    case pro
    
    var description: String {
        switch self {
        case .beginner:
            "Beginner"
        case .intermediate:
            "Intermediate"
        case .advanced:
            "Advanced"
        case .pro:
            "Pro"
        }
    }
    
    var emoji: String {
        switch self {
        case .beginner:
            "👦"
        case .intermediate:
            "🤓"
        case .advanced:
            "👨‍🏫"
        case .pro:
            "🐲"
        }
    }
    
    mutating func setMode(for level: Double) {
        switch level {
        case 0..<7:
            self = .beginner
        case 7..<10:
            self = .intermediate
        case 10..<13:
            self = .advanced
        default:
            self = .pro
        }
    }
}
