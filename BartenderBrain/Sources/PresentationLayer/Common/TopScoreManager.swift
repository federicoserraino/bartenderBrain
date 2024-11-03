//
//  File.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

protocol TopScoreManager: AnyObject {
    func getTopScore() -> Int?
    func setTopScore(_ newScore: Int) -> Bool
}

final class AppTopScoreManager: TopScoreManager {
    static let shared: TopScoreManager = AppTopScoreManager()
    private init() {}
    private let userDefaults: UserDefaults = UserDefaults.standard
    private let topScoreKey: String = "BARTENDER_BRAIN.TOP_SCORE.KEY"
    
    func getTopScore() -> Int? {
        userDefaults.object(forKey: topScoreKey) as? Int
    }
    
    func setTopScore(_ newScore: Int) -> Bool {
        let currentTopScore = getTopScore()
        if currentTopScore == nil || newScore > currentTopScore! {
            userDefaults.setValue(newScore, forKey: topScoreKey)
            return true
        }
        return false
    }
    
}
