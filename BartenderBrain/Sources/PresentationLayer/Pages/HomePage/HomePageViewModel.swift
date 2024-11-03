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
    // Delegate
    weak var delegate: HomePageViewModelDelegate?
    weak var topScoreSender: SubjectSender<Double>?
    
    static let minCocktailPairs: Double = 4
    static let maxCocktailPairs: Double = 15
    @Published var cocktailPairsNum: Double = 4.0
    @Published var challengeMode: ChallengeMode = .easy
    @Published var topScore: String?
    
    init(delegate: HomePageViewModelDelegate, topScoreSender: SubjectSender<Double>) {
        self.delegate = delegate
        self.topScoreSender = topScoreSender
        super.init()
    }
    
    override func bindingProperties() {
        super.bindingProperties()
        $cocktailPairsNum
            .map{ ChallengeMode(for: $0) }
            .receive(on: RunLoop.main)
            .assign(to: \.challengeMode, on: self)
            .store(in: &cancellables)
        
        topScoreSender?.subject
            .map{ $0.stringFormatted }
            .filter{ [weak self] in $0 != self?.topScore }
            .receive(on: RunLoop.main)
            .assign(to: \.topScore, on: self)
            .store(in: &cancellables)
    }
    
    func didTapStartButton() {
        delegate?.startGame(with: cocktailPairsNum.toInt())
    }
    
}
