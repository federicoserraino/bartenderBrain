//
//  File.swift
//  BartenderBrainTests
//
//  Created by Federico Serraino on 05/11/24.
//

import XCTest
@testable import BartenderBrain

final class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataManager = AppCoreDataManager.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataManager = nil
    }
    
    func testCocktailIdsStoring() throws {
        let ids: [String] = ["1111", "2222"]
        try coreDataManager.saveCocktailIds(ids)
        let res = try coreDataManager.fetchCocktailIds()
        XCTAssertTrue(res.contains(ids))
    }
    
}
