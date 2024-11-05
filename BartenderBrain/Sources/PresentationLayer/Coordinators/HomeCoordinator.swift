//
//  HomeCoordinator.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
    var rootViewController: UIViewController!
    var parent: Coordinator?
    var child: Coordinator?
    
    private lazy var topScoreManager: TopScoreManager = { AppTopScoreManager.shared }()
    private lazy var topScoreSender: SubjectSender<Double> = .init()
    
    func start(from window: UIWindow) {
        let vm: HomePageViewModel = .init(delegate: self, topScoreSender: topScoreSender)
        let vc = BaseSwiftUIViewController<HomePageViewModel, HomePageView>(viewModel: vm)
        self.rootViewController = vc
        window.rootViewController = vc
        window.makeKeyAndVisible()
        sendTopScore()
    }
    
    private func sendTopScore() {
        guard let topScore = topScoreManager.getTopScore() else { return }
        topScoreSender.sendValue(topScore)
    }
    
    func removeChild() {
        child = nil
        sendTopScore()
    }
}

extension HomeCoordinator: HomePageViewModelDelegate {
    func startGame(with cocktailPairsNum: Int) {
        let gameCoordinator: GameCoordinator = .init(cocktailPairsNum: cocktailPairsNum)
        child = gameCoordinator
        gameCoordinator.start(from: self)
    }
}
