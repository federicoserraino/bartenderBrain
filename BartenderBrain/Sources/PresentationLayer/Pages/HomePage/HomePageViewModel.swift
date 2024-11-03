//
//  HomePageViewModel.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import Combine

protocol HomePageViewModelDelegate: AnyObject {
    func startGame(with cocktailPairsNum: Int)
}

class HomePageViewModel: BaseViewModel {
    
    weak var delegate: HomePageViewModelDelegate?
    
    static let minCocktailPairs: Double = 4
    static let maxCocktailPairs: Double = 15
    @Published var cocktailPairsNum: Double = 4.0
    @Published var challengeMode: ChallengeMode = .easy
    
    init(delegate: HomePageViewModelDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    override func bindingProperties() {
        super.bindingProperties()
        $cocktailPairsNum
            .map{ ChallengeMode(for: $0) }
            .receive(on: RunLoop.main)
            .assign(to: \.challengeMode, on: self)
            .store(in: &cancellables)
    }
    
    func didTapStartButton() {
        delegate?.startGame(with: cocktailPairsNum.toInt())
    }
    
}
