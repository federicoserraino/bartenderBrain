//
//  GamePageViewModel.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation
import UIKit
import Combine

protocol GamePageViewModelDelegate: AnyObject {
    func didTapOnMenuButton(onNewGamePressed: @escaping () -> Void)
    func gameDidEnd(with score: Int, after time: Int)
}

class GamePageViewModel: BaseViewModel {
    weak var delegate: GamePageViewModelDelegate?
    // Unique Cocktails to find
    private let cockstails: [CocktailDetails]
    // Grid dimension
    private(set) var columnsCount: Int = 0
    private(set) var rowsCount: Int = 0
    private var missingElementsToCompleteGrid: Int = 0
    // Score Properties
    private let matchesToFind: Int
    private var matchesFound: Int = 0
    private var attempsPerImage: [UIImage:Int] = [:]
    @Published var score: Int = 0
    // CardsDeck Properties
    @Published var cardsDeck: [GameCard] = []
    private var selectedCard: GameCard?
    // Timer Properties
    @Published private var previewTimerValue: Int = 3
    @Published private var timerValue: Int = 0
    @Published var timerValueDescription: String = ""
    private var previewTimerCancellables: AnyCancellable?
    
    init(cockstails: [CocktailDetails], delegate: GamePageViewModelDelegate) {
        self.cockstails = cockstails
        self.delegate = delegate
        matchesToFind = cockstails.count
        super.init()
        setupGameGrid()
        setupCardsDeck()
    }
    
    override func bindingProperties() {
        super.bindingProperties()
        $previewTimerValue
            .map{ "\($0)" }
            .receive(on: RunLoop.main)
            .assign(to: \.timerValueDescription, on: self)
            .store(in: &cancellables)
        
        $timerValue
            .map{ $0.timeFormatFromSeconds }
            .receive(on: RunLoop.main)
            .assign(to: \.timerValueDescription, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Public Method
    func beginGame() {
        showCardsPreviewAndStartGame()
    }
    
    func endGame() {
        cancellables.removeAll()
    }
    
    func didtapOnMenu() {
        delegate?.didTapOnMenuButton(onNewGamePressed: restartGame)
    }
    
    // MARK - Private Methods
    private func setupGameGrid() {
        guard matchesToFind > 0 else { return }
        let itemsCount = matchesToFind * 2
        columnsCount = Int(sqrt(Double(itemsCount)).rounded())
        rowsCount = (itemsCount + columnsCount - 1) / columnsCount
        missingElementsToCompleteGrid = (columnsCount * rowsCount) % itemsCount
    }
    
    private func setupCardsDeck() {
        var cardsDeck: [GameCard] = cockstails
            .map{ GameCard(id: $0.id, image: $0.image) }
            .flatMap{ [$0, $0.makeDuplicate()] }
            .shuffled()
        // Add Logo cards to make the grid as square as possible
        switch missingElementsToCompleteGrid {
        case 1: // Add logo to center
            cardsDeck.insert(GameCard.makeLogoCard(), at: cardsDeck.count/2)
        case 2: // Add logos in top-left and bottom-right corners
            cardsDeck.insert(GameCard.makeLogoCard(), at: 0)
            cardsDeck.append(GameCard.makeLogoCard())
        case 3: // Add logos center, in top-left and bottom-right corners
            cardsDeck.insert(GameCard.makeLogoCard(), at: cardsDeck.count/2)
            cardsDeck.insert(GameCard.makeLogoCard(), at: 0)
            cardsDeck.append(GameCard.makeLogoCard())
        case 4: // Add logos in corners
            let topRightIndex = columnsCount - 1
            let bottomLeftIndex = (rowsCount - 1) * columnsCount
            cardsDeck.insert(GameCard.makeLogoCard(), at: 0)
            cardsDeck.insert(GameCard.makeLogoCard(), at: topRightIndex)
            cardsDeck.insert(GameCard.makeLogoCard(), at: bottomLeftIndex)
            cardsDeck.append(GameCard.makeLogoCard())
        default:
            break
        }
        self.cardsDeck = cardsDeck
    }
    
    private func resetScore() {
        score = 0
        matchesFound = 0
        attempsPerImage.removeAll()
        selectedCard = nil
    }
    
    private func showCardsPreviewAndStartGame() {
        previewTimerValue = 3
        let previewTimerCancellables = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in guard let self else { return }
                if previewTimerValue > 0 {
                    previewTimerValue -= 1
                } else {
                    self.previewTimerCancellables?.cancel()
                    startGame()
                }
            })
        self.previewTimerCancellables = previewTimerCancellables
        cancellables.insert(previewTimerCancellables)
    }
    
    private func startGame() {
        timerValue = 0
        Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .scan(0) { count, _ in count + 1 }
            .assign(to: \.timerValue, on: self)
            .store(in: &cancellables)
        flipAllCards()
    }
    
    private func restartGame() {
        endGame()
        resetScore()
        bindingProperties()
        setupCardsDeck()
        showCardsPreviewAndStartGame()
    }
    
    private func flipAllCards() {
        cardsDeck.forEach { card in
            if !card.isLogoCard { card.isFlipped = true }
        }
    }
    
    private func flipCards(cards: [GameCard], after time: TimeInterval = 0.8) {
        // Adddd delay to enhance UX
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            cards.forEach{ $0.isFlipped = true }
        }
    }
    
    func didTapOnCard(_ card: GameCard) {
        guard !card.isLogoCard, card.isFlipped else { return }
        
        card.isFlipped = false
        if let selectedCard {
            if selectedCard.image == card.image {
                // Match Found! :D
                handleMatchFound(for: card.image)
            } else {
                // Wrong match :(
                increaseAttempsPerImage(card.image)
                flipCards(cards: [card, selectedCard])
            }
            self.selectedCard = nil
        } else {
            increaseAttempsPerImage(card.image)
            selectedCard = card
        }
    }
    
    private func increaseAttempsPerImage(_ image: UIImage) {
        if let attemps = attempsPerImage[image] {
            attempsPerImage[image] = attemps + 1
        } else {
            attempsPerImage[image] = 1
        }
    }
    
    private func handleMatchFound(for image: UIImage) {
        matchesFound += 1
        if let attemps = attempsPerImage[image] {
            let cardScore: Int
            switch attemps {
            case 0..<2:
                cardScore = 4
            case 2..<4:
                cardScore = 2
            default:
                cardScore = 1
            }
            score += cardScore
        }
        checkIfGameIsOver()
    }
    
    private func checkIfGameIsOver() {
        guard matchesFound == matchesToFind else { return }
        endGame()
        delegate?.gameDidEnd(with: score, after: timerValue)
    }
    
}
