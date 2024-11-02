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
    func didPressCloseButton()
    func didEndGame(with score: Int)
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
    @Published var timerValue: String = ""
    
    init(cockstails: [CocktailDetails], delegate: GamePageViewModelDelegate) {
        self.cockstails = cockstails
        self.delegate = delegate
        matchesToFind = cockstails.count
        super.init()
        setupCardsDeck()
    }
    
    func prepareGame() {
        resetScore()
        startPreviewGame()
    }
    
    func cleanGameMemory() {
        cancellables.removeAll()
    }
    
    // MARK - Private Methods
    
    private func setupCardsDeck() {
        var cardsDeck: [GameCard] = cockstails
            .map{ GameCard(id: $0.id, image: $0.image) }
            .flatMap{ [$0, $0.makeDuplicate()] }
            .shuffled()
        //TODO: Aggiungere logica logo card
        self.cardsDeck = cardsDeck
    }
    
    private func resetScore() {
        score = 0
        matchesFound = 0
        attempsPerImage.removeAll()
    }
    
    private func startPreviewGame() {
        var previewTimerValue: Int = 3
        timerValue = "\(previewTimerValue)"
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in guard let self else { return }
                if previewTimerValue > 0 {
                    previewTimerValue -= 1
                    timerValue = "\(previewTimerValue)"
                } else {
                    cancellables.removeAll()
                    startGame()
                }
            })
            .store(in: &cancellables)
    }
    
    private func startGame() {
        timerValue = 0.timeFormatFromSeconds
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .scan(0) { count, _ in count + 1 }
            .map { $0.timeFormatFromSeconds }
            .assign(to: \.timerValue, on: self)
            .store(in: &cancellables)
        flipAllCards()
    }
    
    private func flipAllCards() {
        cardsDeck.forEach { card in
            if !card.isLogoCard { card.isFlipped = true }
        }
    }
    
    private func flipCards(cards: [GameCard], after time: TimeInterval = 0.8) {
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
        //TODO: Calcolare punti in base a difficoltà e tempo
        delegate?.didEndGame(with: score)
        print("Game over!")
    }
    
}
