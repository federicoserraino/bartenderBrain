//
//  ChallengeMode.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

enum ChallengeMode {
    case easy
    case medium
    case hard
    case pro
    
    var description: String {
        switch self {
        case .easy:
            "Easy"
        case .medium:
            "Medium"
        case .hard:
            "Hard"
        case .pro:
            "Pro"
        }
    }
    
    var emoji: String {
        switch self {
        case .easy:
            "👦"
        case .medium:
            "🤓"
        case .hard:
            "👨‍🏫"
        case .pro:
            "🐲"
        }
    }
    
    mutating func setMode(for level: Double) {
        switch level {
        case 0..<7:
            self = .easy
        case 7..<10:
            self = .medium
        case 10..<13:
            self = .hard
        default:
            self = .pro
        }
    }
}
