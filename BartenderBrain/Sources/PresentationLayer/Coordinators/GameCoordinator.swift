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
    
    init(cocktailPairsNum: Int, networkProvier: NetworkProvier = AppNetworkProvier.shared) {
        self.cocktailPairsNum = cocktailPairsNum
        self.networkProvier = networkProvier
    }
    
    func start(from coordinator: Coordinator?) {
        parent = coordinator
        Task {
            do {
                cocktails = try await fetchCocktails()
            } catch {
                await MainActor.run { [weak self] in self?.showNetworkErrorPopup(for: error as? NetworkError) }
                return
            }
            
            await MainActor.run { [weak self] in guard let self else { return }
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
        
        try await withThrowingTaskGroup(of: RandomCocktailOutput.self) { group in
            let getRandomCocktail: @Sendable () async throws -> RandomCocktailOutput = { [weak self] in
                guard let self else { throw NetworkError.unknownError(code: "RC01") }
                return try await networkProvier.getRandomCocktail()
            }
            
            for _ in 0..<cocktailPairsNum {
                group.addTask(operation: getRandomCocktail)
            }
            
            for try await result in group {
                if cocktails.contains(result) { // TODO: aggiungere controllo su cocktail dei precedenti round
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
            .title(text: "Attenzione"),
            .text(text: "Si è verificato un problema tecnico.\nSi prega di riprovare più tardi.", topPadding: 20),
        ]
        
        if let codeError = error?.codeError {
            popupItems.append(.text(text: "CODE ERROR: \(codeError)", font: .system(size: 10, weight: .semibold)))
        }
        
        rootViewController = PopupView(
            items: popupItems,
            estimatedSize: .init(width: 300, height: 220),
            bottomButton: (text: "ok", action: { [weak self] in self?.dismissCoordinator() })
        ).viewControllerEmbedded
        
        parentVC.present(rootViewController, animated: true)
    }
    
}

extension GameCoordinator: GamePageViewModelDelegate {
    func didTapOnMenuButton(onNewGamePressed: @escaping () -> Void) {
        popupVC = PopupView(
            items: [
                .title(text: "Menu"),
                .iconWithText(
                    icon: .icon_cards,
                    size: .init(width: 40, height: 40),
                    text: "Restart Game",
                    topPadding: 20,
                    action: { [weak self] in self?.popupVC?.dismiss(animated: true, completion: onNewGamePressed) }
                ),
                .iconWithText(
                    icon: .icon_cancel,
                    size: .init(width: 20, height: 20),
                    text: "Quit Game",
                    topPadding: 25,
                    action: { [weak self] in self?.dismissCoordinatorFromPopup() }
                )
            ],
            bottomButton: (text: "Close", action: { [weak self] in self?.popupVC?.dismiss(animated: true) })
        ).viewControllerEmbedded
        
        rootViewController.present(popupVC!, animated: true)
    }
    
    func gameDidEnd(with score: Int, after time: Int) {
        // TODO: Compute new score
        var popupItems: [PopupItem] = [
            .title(text: "Well done!"),
            .text(text: "Score: \(score)", alignment: .leading),
            .text(text: "Time: \(time.timeFormatFromSeconds)", alignment: .leading),
            .text(text: "Mode: \(ChallengeMode(for: Double(cocktailPairsNum)).emoji)", alignment: .leading),
            .divider(),
            .text(text: "Total score:\t \(score*2)", font: .system(size: 14, weight: .semibold))
        ]
        let newScoreAdded = TopScoreManager.shared.setTopScore(score)
        if newScoreAdded {
            popupItems.append(.text(text: "🔥 NEW RECORD ", font: .system(size: 10, weight: .bold)))
        }
        
        popupVC = PopupView(
            items: popupItems,
            bottomButton: (text: "ok", action: { [weak self] in self?.dismissCoordinatorFromPopup() })
        ).viewControllerEmbedded
       
        // Add delay to enhance UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self, let popupVC else { return }
            rootViewController.present(popupVC, animated: true)
        }
    }
    
    private func dismissCoordinatorFromPopup() {
        popupVC?.dismiss(animated: false) { [weak self] in
            self?.dismissCoordinator()
        }
    }
    
}
