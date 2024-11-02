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
    
    func didTapOnCard(_ card: GameCard) {
        /*
        guard !card.isFlipped else { return }
        if let index = cardsDeck.firstIndex(where: { $0.id == card.id }) {
            cardsDeck[index] = card.copyWith(isFlipped: true)
            //objectWillChange.send()
        }
         */
    }
    
}
