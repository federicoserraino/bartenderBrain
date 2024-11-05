//
//  File.swift
//  BartenderBrainTests
//
//  Created by Federico Serraino on 05/11/24.
//

import XCTest
@testable import BartenderBrain

final class TopScoreManagerTests: XCTestCase {
    
    var topScoreManager: TopScoreManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        topScoreManager = AppTopScoreManager.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        topScoreManager = nil
    }
    
    func testSetNewTopScore() {
        let actualTopScore = topScoreManager.getTopScore() ?? 0
        let newTopScore = actualTopScore + 1
        let res = topScoreManager.setTopScore(newTopScore)
        XCTAssertTrue(res)
    }
    
}
