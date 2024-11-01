//
//  File.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

final class TopScoreManager {
    
    private init() {}
    static let shared: TopScoreManager = .init()
    private let userDefaults: UserDefaults = UserDefaults.standard
    private let topScoreKey: String = "BARTENDER_BRAIN.TOP_SCORE.KEY"
    
    func getTopScore() -> Int? {
        userDefaults.object(forKey: topScoreKey) as? Int
    }
    
    func setTopScore(_ newScore: Int) {
        let currentTopScore = getTopScore()
        if currentTopScore == nil || newScore > currentTopScore! {
            userDefaults.setValue(newScore, forKey: topScoreKey)
        }
    }
    
}
