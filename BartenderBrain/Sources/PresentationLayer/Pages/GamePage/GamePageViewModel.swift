//
//  GamePageViewModel.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 01/11/24.
//

import Foundation
import Combine

class GamePageViewModel: BaseViewModel {
    
    private let cockstails: [CocktailDetails]
    @Published var cardsDeck: [GameCard] = []
    @Published var timerValue: String = ""
    private var selectedCard: GameCard?
    
    init(cockstails: [CocktailDetails]) {
        self.cockstails = cockstails
        super.init()
        setupCardsDeck()
    }
    
    private func setupCardsDeck() {
        var cardsDeck: [GameCard] = cockstails
            .map{ GameCard(id: $0.id, image: $0.image) }
            .flatMap{ [$0, $0.copyWith(id: $0.id + "_2")] }
            .shuffled()
        //TODO: Aggiungere logica logo card
        self.cardsDeck = cardsDeck
    }
    
    func prepareGame() {
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
            } else {
                // Wrong match :(
                flipCards(cards: [card, selectedCard])
                // TODO: gestione punti in caso di errore
            }
            self.selectedCard = nil
        } else {
            selectedCard = card
        }
    }
    
}
