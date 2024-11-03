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
    
    func prepareAndStartGame() {
        resetScore()
        setupCardsDeck()
        startPreviewGame()
    }
    
    func endGame() {
        cancellables.removeAll()
    }
    
    func didtapOnMenu() {
        delegate?.didTapOnMenuButton(onNewGamePressed: restartGame)
    }
    
    // MARK - Private Methods
    private func resetScore() {
        score = 0
        matchesFound = 0
        attempsPerImage.removeAll()
        selectedCard = nil
    }
    
    private func setupCardsDeck() {
        //TODO: Aggiungere logica logo card
        var cardsDeck: [GameCard] = cockstails
            .map{ GameCard(id: $0.id, image: $0.image) }
            .flatMap{ [$0, $0.makeDuplicate()] }
            .shuffled()
        self.cardsDeck = cardsDeck
    }
    
    private func startPreviewGame() {
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
        bindingProperties()
        prepareAndStartGame()
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
