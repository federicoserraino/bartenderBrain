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
            .text(text: "Si è verificato un problema tecnico.\nSi prega di riprovare più tardi.", font: .system(size: 14), topPadding: 20),
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
    func didTapOnMenuButton() {
        // TODO Mostrare popup are u sure?
        popupVC = PopupView(
            items: [
                //.text(text: "Menu", font: .system(size: 24, weight: .bold), topPadding: 30)
                //.iconWithText(icon: <#T##UIImage#>, text: <#T##String#>, topPadding: <#T##CGFloat#>, action: <#T##() -> Void#>)
                
            ],
            bottomButton: (text: "Chiudi", action: { [weak self] in
                self?.popupVC?.dismiss(animated: true)
            })
        ).viewControllerEmbedded
    }
    
    func didEndGame(with score: Int) {
        // TODO Mostrare popup con recap punti, tap su OK dismette coordinator
        popupVC = PopupView(
            items: [/*.text(text: "Hai totalizzato: \(score)", font: .system(size: 20), topPadding: 50)*/],
            bottomButton: (text: "ok", action: { [weak self] in
                self?.dismissCoordinatorFromPopup()
            })
        ).viewControllerEmbedded
       
        // Adddd delay to enhance UX
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
