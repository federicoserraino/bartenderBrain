//
//  File.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation

protocol TopScoreManager: AnyObject {
    func getTopScore() -> Double?
    func setTopScore(_ newScore: Double) -> Bool
}

final class AppTopScoreManager: TopScoreManager {
    static let shared: TopScoreManager = AppTopScoreManager()
    private init() {}
    private let userDefaults: UserDefaults = UserDefaults.standard
    private let topScoreKey: String = "BARTENDER_BRAIN.TOP_SCORE.KEY"
    
    func getTopScore() -> Double? {
        userDefaults.object(forKey: topScoreKey) as? Double
    }
    
    func setTopScore(_ newScore: Double) -> Bool {
        let currentTopScore = getTopScore()
        if currentTopScore == nil || newScore > currentTopScore! {
            userDefaults.setValue(newScore, forKey: topScoreKey)
            return true
        }
        return false
    }
    
}
