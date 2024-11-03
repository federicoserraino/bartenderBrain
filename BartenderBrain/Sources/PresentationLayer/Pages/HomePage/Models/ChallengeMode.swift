//
//  ChallengeMode.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

enum ChallengeMode: String {
    case easy
    case medium
    case hard
    case pro
    
    init(for level: Double) {
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
    
    var description: String {
        self.rawValue.capitalized + " " + self.emoji
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
    
}
