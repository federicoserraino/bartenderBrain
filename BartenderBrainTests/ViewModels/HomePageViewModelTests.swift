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
    
    private let subbedHomePageViewModelDelegate: SubbedHomePageViewModelDelegate = .init()
    private let stubbedTopScoreSender: SubjectSender<Double> = .init()
    private var homePageVM: HomePageViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        subbedHomePageViewModelDelegate.resetDelegate()
        homePageVM = .init(delegate: subbedHomePageViewModelDelegate, topScoreSender: stubbedTopScoreSender)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homePageVM = nil
        cancellables.removeAll()
    }

    func testDidTapStartButton() throws {
        homePageVM.didTapStartButton()
        let res = subbedHomePageViewModelDelegate.startGameCalled
        XCTAssertTrue(res)
    }
    
    func testDidTapStartButton2() throws {
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

class SubbedHomePageViewModelDelegate: HomePageViewModelDelegate {
    var startGameCalled: Bool = false
    
    func startGame(with cocktailPairsNum: Int) {
        startGameCalled = true
    }
    
    func resetDelegate() {
        startGameCalled = false
    }
    
}
