//
//  GamePageViewModelTests.swift
//  BartenderBrainTests
//
//  Created by Federico Serraino on 05/11/24.
//

import XCTest
import Combine
@testable import BartenderBrain

final class GamePageViewModelTests: XCTestCase {
    
    private let stubbedHomePageViewModelDelegate: StubbedGamePageViewModelDelegate = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        stubbedHomePageViewModelDelegate.resetDelegate()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }
    
    func testSetupDeckWith0Cards() {
        let cards: [CocktailDetails] = []
        let logoCardNum = 0
        let expectedCards = (cards.count * 2) + logoCardNum
        let sut = GamePageViewModel(cockstails: cards, delegate: stubbedHomePageViewModelDelegate)
        let res = sut.cardsDeck.count
        XCTAssertEqual(res, expectedCards)
    }

    func testSetupDeckWith4Cards() {
        let cards: [CocktailDetails] = Array(repeating: CocktailDetails(id: "id", image: UIImage()), count: 4)
        let logoCardNum = 1
        let expectedCards = (cards.count * 2) + logoCardNum
        let sut = GamePageViewModel(cockstails: cards, delegate: stubbedHomePageViewModelDelegate)
        let res = sut.cardsDeck.count
        XCTAssertEqual(res, expectedCards)
    }
    
    func testSetupDeckWith5Cards() {
        let cards: [CocktailDetails] = Array(repeating: CocktailDetails(id: "id", image: UIImage()), count: 5)
        let logoCardNum = 2
        let expectedCards = (cards.count * 2) + logoCardNum
        let sut = GamePageViewModel(cockstails: cards, delegate: stubbedHomePageViewModelDelegate)
        let res = sut.cardsDeck.count
        XCTAssertEqual(res, expectedCards)
    }
    
    func testSetupDeckWith11Cards() {
        let cards: [CocktailDetails] = Array(repeating: CocktailDetails(id: "id", image: UIImage()), count: 11)
        let logoCardNum = 3
        let expectedCards = (cards.count * 2) + logoCardNum
        let sut = GamePageViewModel(cockstails: cards, delegate: stubbedHomePageViewModelDelegate)
        let res = sut.cardsDeck.count
        XCTAssertEqual(res, expectedCards)
    }
    
    func testSetupDeckWith13Cards() {
        let cards: [CocktailDetails] = Array(repeating: CocktailDetails(id: "id", image: UIImage()), count: 13)
        let logoCardNum = 4
        let expectedCards = (cards.count * 2) + logoCardNum
        let sut = GamePageViewModel(cockstails: cards, delegate: stubbedHomePageViewModelDelegate)
        let res = sut.cardsDeck.count
        XCTAssertEqual(res, expectedCards)
    }
    
    func testBeginGame() {
        let cards: [CocktailDetails] = [.init(id: "id", image: UIImage())]
        let sut = GamePageViewModel(cockstails: cards, delegate: stubbedHomePageViewModelDelegate)
        let expectation = XCTestExpectation()
        
        sut.$timerValueDescription
            .filter{ $0.matchStartTimeFormat }
            .sink(receiveValue: { value in
                XCTAssertTrue(value.matchStartTimeFormat)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        sut.beginGame()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDidtapOnMenu() {
        let sut = GamePageViewModel(cockstails: [], delegate: stubbedHomePageViewModelDelegate)
        sut.didtapOnMenu()
        let res = stubbedHomePageViewModelDelegate.didTapOnMenuButtoneCalled
        XCTAssertTrue(res)
    }
    
    func testDidTapOnCardMatchFound() {
        let image: UIImage = .checkmark
        let card: CocktailDetails = .init(id: "id", image: image)
        let gameCard1: GameCard = .init(id: "id1", image: image, isFlipped: true)
        let gameCard2: GameCard = .init(id: "id2", image: image, isFlipped: true)
        let sut = GamePageViewModel(cockstails: [card], delegate: stubbedHomePageViewModelDelegate)
        sut.didTapOnCard(gameCard1)
        XCTAssertFalse(gameCard1.isFlipped)
        sut.didTapOnCard(gameCard2)
        XCTAssertFalse(gameCard2.isFlipped)
        let gameDidEnd = stubbedHomePageViewModelDelegate.gameDidEndCalled
        XCTAssertTrue(gameDidEnd)
    }
    
    func testDidTapOnCardMatchNotFound() {
        let image1: UIImage = .checkmark
        let image2: UIImage = .add
        let card: CocktailDetails = .init(id: "id", image: image1)
        let gameCard1: GameCard = .init(id: "id1", image: image1, isFlipped: true)
        let gameCard2: GameCard = .init(id: "id2", image: image2, isFlipped: true)
        let sut = GamePageViewModel(cockstails: [card], delegate: stubbedHomePageViewModelDelegate)
        sut.didTapOnCard(gameCard1)
        XCTAssertFalse(gameCard1.isFlipped)
        sut.didTapOnCard(gameCard2)
        XCTAssertFalse(gameCard2.isFlipped)
        let gameDidEnd = stubbedHomePageViewModelDelegate.gameDidEndCalled
        XCTAssertFalse(gameDidEnd)
    }

}

fileprivate class StubbedGamePageViewModelDelegate: GamePageViewModelDelegate {
    var didTapOnMenuButtoneCalled: Bool = false
    var gameDidEndCalled: Bool = false
    
    func didTapOnMenuButton(onNewGamePressed: @escaping () -> Void) {
        onNewGamePressed()
        didTapOnMenuButtoneCalled = true
    }
    
    func gameDidEnd(with score: Int, after time: Int) {
        gameDidEndCalled = true
    }
    
    func resetDelegate() {
        didTapOnMenuButtoneCalled = false
        gameDidEndCalled = false
    }
    
}

fileprivate extension String {
    var matchStartTimeFormat: Bool {
        let regexPattern = #"^00:0[1-9]$"#
        let isValidFormat = self.range(of: regexPattern, options: .regularExpression) != nil
        return isValidFormat
    }
}

