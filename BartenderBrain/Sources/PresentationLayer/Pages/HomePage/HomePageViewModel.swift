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
    @Published var challengeMode: ChallengeMode = .beginner
    
    init(delegate: HomePageViewModelDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    override func bindingProperties() {
        super.bindingProperties()
        $cocktailPairsNum
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.challengeMode.setMode(for: value)
            })
            .store(in: &cancellables)
    }
    
    func didTapStartButton() {
        delegate?.startGame(with: cocktailPairsNum.toInt())
    }
    
}
