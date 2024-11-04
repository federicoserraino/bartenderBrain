//
//  GameCoordinator.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit
import SwiftUI

final class GameCoordinator: Coordinator {
    var rootViewController: UIViewController!
    var parent: Coordinator?
    var child: Coordinator?
    
    private let cocktailPairsNum: Int
    private var cocktails: [CocktailDetails] = []
    private let networkProvier: NetworkProvier
    private var popupVC: UIViewController?
    
    private lazy var coreDataManager: CoreDataManager = { AppCoreDataManager.shared }()
    private lazy var loaderManager: LoaderManager = { AppLoaderManager.shared }()
    private lazy var topScoreManager: TopScoreManager = { AppTopScoreManager.shared }()
    
    init(cocktailPairsNum: Int, networkProvier: NetworkProvier = AppNetworkProvier.shared) {
        self.cocktailPairsNum = cocktailPairsNum
        self.networkProvier = networkProvier
    }
    
    func start(from coordinator: Coordinator?) {
        parent = coordinator
        Task { [weak self] in guard let self else { return }
            do {
                await loaderManager.showLoader()
                cocktails = try await fetchCocktails()
            } catch {
                await loaderManager.hideLoader()
                await showNetworkErrorPopup(for: error as? NetworkError)
                return
            }
            
            await MainActor.run { [weak self] in guard let self else { return }
                loaderManager.hideLoader()
                let vm = GamePageViewModel(cockstails: cocktails, delegate: self)
                let vc = BaseSwiftUIViewController<GamePageViewModel, GamePageView>(viewModel: vm)
                rootViewController = vc
                rootViewController.modalPresentationStyle = .fullScreen
                parent?.rootViewController.present(rootViewController, animated: true)
            }
        }
    }
    
    private func fetchCocktails() async throws -> [CocktailDetails] {
        let randomCocktails = try await downloadRandomCocktails()
        return try await downloadCocktailImages(for: randomCocktails)
    }
    
    private func downloadRandomCocktails() async throws -> Set<RandomCocktailOutput> {
        var cocktails: Set<RandomCocktailOutput> = Set()
        // Try to retrieve CocktailIds used during previous rounds - Error is not locking
        let previousRoundCocktailIds: [String] = (try? coreDataManager.fetchCocktailIds()) ?? []
        try await withThrowingTaskGroup(of: RandomCocktailOutput.self) { group in
            let getRandomCocktail: @Sendable () async throws -> RandomCocktailOutput = { [weak self] in
                guard let self else { throw NetworkError.unknownError(code: "RC01") }
                return try await networkProvier.getRandomCocktail()
            }
            
            for _ in 0..<cocktailPairsNum {
                group.addTask(operation: getRandomCocktail)
            }
            
            for try await result in group {
                if cocktails.contains(result) || previousRoundCocktailIds.contains(result.id) {
                    group.addTask(operation: getRandomCocktail)
                } else {
                    cocktails.insert(result)
                }
            }
        }
        
        return cocktails
    }
    
    private func downloadCocktailImages(for cocktails: Set<RandomCocktailOutput>) async throws -> [CocktailDetails] {
        var cocktailCards: [CocktailDetails] = []
        
        try await withThrowingTaskGroup(of: CocktailDetails.self) { group in
            cocktails.forEach { cocktail in
                group.addTask { [weak self] in
                    guard let cocktailData = try await self?.networkProvier.getCocktailImageData(from: cocktail.thumbUrl),
                          let cocktailImage = UIImage(data: cocktailData) else {
                        throw NetworkError.unknownError(code: "RC02")
                    }
                    return .init(id: cocktail.id, image: cocktailImage)
                }
            }
            
            for try await result in group {
                cocktailCards.append(result)
            }
        }
        
        return cocktailCards
    }
    
    @MainActor
    private func showNetworkErrorPopup(for error: NetworkError?) {
        guard let parentVC = parent?.rootViewController else { return }
        var popupItems: [PopupItem] = [
            .title(text: "GAME_PAGE.NETWORK_ERROR.TITLE".localized),
            .text(text: "GAME_PAGE.NETWORK_ERROR.DESC".localized, topPadding: 20),
        ]
        
        if let codeError = error?.codeError {
            popupItems.append(.text(text: "GAME_PAGE.NETWORK_ERROR.CODE_ERROR".localized + codeError, font: .system(size: 10, weight: .semibold)))
        }
        
        rootViewController = PopupView(
            items: popupItems,
            estimatedSize: .init(width: 300, height: 220),
            bottomButton: (text: "OK_BUTTON".localized, action: { [weak self] in self?.dismissCoordinator() })
        ).viewControllerEmbedded
        
        parentVC.present(rootViewController, animated: true)
    }
    
    private func storeCocktails() {
        // Try to save CocktailIds used during round - Error is not locking
        try? coreDataManager.saveCocotailIds(cocktails.map{ $0.id })
    }
}

extension GameCoordinator: GamePageViewModelDelegate {
    func didTapOnMenuButton(onNewGamePressed: @escaping () -> Void) {
        popupVC = PopupView(
            items: [
                .title(text: "GAME_PAGE.MENU.TITLE".localized),
                .iconWithText(
                    icon: .icon_cards,
                    size: .init(width: 40, height: 40),
                    text: "GAME_PAGE.MENU.RESTAT".localized,
                    topPadding: 20,
                    action: { [weak self] in self?.popupVC?.dismiss(animated: true, completion: onNewGamePressed) }
                ),
                .iconWithText(
                    icon: .icon_cancel,
                    size: .init(width: 20, height: 20),
                    text: "GAME_PAGE.MENU.QUIT".localized,
                    topPadding: 25,
                    action: { [weak self] in self?.dismissCoordinatorFromPopup() }
                )
            ],
            bottomButton: (text: "CLOSE_BUTTON".localized, action: { [weak self] in self?.popupVC?.dismiss(animated: true) })
        ).viewControllerEmbedded
        
        rootViewController.present(popupVC!, animated: true)
    }
    
    func gameDidEnd(with score: Int, after time: Int) {
        let challegeMode = ChallengeMode(for: cocktailPairsNum.toDouble())
        let timePenalty = time / 10
        let bonusMultiplier = challegeMode.bonusScoreMultiplier
        let totalScore: Double = (score - timePenalty).toDouble() * bonusMultiplier
        var popupItems: [PopupItem] = [
            .title(text: "GAME_PAGE.END_GAME_POUP.TITLE".localized),
            .text(text: "GAME_PAGE.END_GAME_POUP.SCORE".localized + " → \(score)", alignment: .leading),
            .text(text: "GAME_PAGE.END_GAME_POUP.TIME".localized + " → \(time.timeFormatFromSeconds)", alignment: .leading),
            .text(text: "GAME_PAGE.END_GAME_POUP.MODE".localized + " → \(challegeMode.emoji)", alignment: .leading),
            .divider(),
            .text(text: "GAME_PAGE.END_GAME_POUP.FINAL_SCORE".localized + " → \(totalScore.stringFormatted)", font: .system(size: 14, weight: .semibold))
        ]
        let newScoreAdded = topScoreManager.setTopScore(totalScore)
        if newScoreAdded {
            popupItems.append(.text(text: "🔥 " + "GAME_PAGE.END_GAME_POUP.RECORD".localized, font: .system(size: 10, weight: .bold), topPadding: 5))
        }
        
        popupVC = PopupView(
            items: popupItems,
            bottomButton: (text: "OK_BUTTON".localized, action: { [weak self] in self?.dismissCoordinatorFromPopup() })
        ).viewControllerEmbedded
       
        // Add delay to enhance UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self, let popupVC else { return }
            rootViewController.present(popupVC, animated: true)
        }
        
        // Store cocktails used during round
        storeCocktails()
    }
    
    private func dismissCoordinatorFromPopup() {
        popupVC?.dismiss(animated: false) { [weak self] in
            self?.dismissCoordinator()
        }
    }
    
}
