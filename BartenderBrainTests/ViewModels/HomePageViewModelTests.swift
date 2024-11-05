//
//  HomePageViewModelTests.swift
//  BartenderBrainTests
//
//  Created by Federico Serraino on 05/11/24.
//

import XCTest
import Combine
@testable import BartenderBrain

final class HomePageViewModelTests: XCTestCase {
    
    private let stubbedHomePageViewModelDelegate: StubbedHomePageViewModelDelegate = .init()
    private let stubbedTopScoreSender: SubjectSender<Double> = .init()
    private var homePageVM: HomePageViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        stubbedHomePageViewModelDelegate.resetDelegate()
        homePageVM = .init(delegate: stubbedHomePageViewModelDelegate, topScoreSender: stubbedTopScoreSender)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homePageVM = nil
        cancellables.removeAll()
    }

    func testDidTapStartButton()  {
        homePageVM.didTapStartButton()
        let res = stubbedHomePageViewModelDelegate.startGameCalled
        XCTAssertTrue(res)
    }
    
    func testTopScoreSender() throws {
        let value: Double = 10
        let expectation = XCTestExpectation()
        
        stubbedTopScoreSender
            .subject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in expectation.fulfill() })
            .store(in: &cancellables)
        
        stubbedTopScoreSender.sendValue(10)
        wait(for: [expectation], timeout: 5.0)
        let res = homePageVM.topScore
        XCTAssertEqual(value.stringFormatted, res)
    }

}

fileprivate class StubbedHomePageViewModelDelegate: HomePageViewModelDelegate {
    var startGameCalled: Bool = false
    
    func startGame(with cocktailPairsNum: Int) {
        startGameCalled = true
    }
    
    func resetDelegate() {
        startGameCalled = false
    }
    
}
