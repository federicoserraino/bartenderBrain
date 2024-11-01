//
//  GameCoordinator.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 30/10/24.
//

import Foundation
import UIKit

final class GameCoordinator: Coordinator {
    var rootViewController: UIViewController!
    var parent: Coordinator?
    var child: Coordinator?
    
    private let cocktailPairsNum: Int
    private let networkProvier: NetworkProvier
    
    init(cocktailPairsNum: Int, networkProvier: NetworkProvier = AppNetworkProvier.shared) {
        self.cocktailPairsNum = cocktailPairsNum
        self.networkProvier = networkProvier
    }
    
    func start(from coordinator: Coordinator?) {
        parent = coordinator
        Task {
            do {
                let cocktailsCard = try await fetchCocktailCards()
            } catch {
                // TODO: Mostrare popup di errore e terminare la navigazione
            }
            
            await MainActor.run { [weak self] in guard let self else { return }
                
            }
            
        }
    }
    
    private func fetchCocktailCards() async throws -> [CocktailCard] {
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
    
    private func downloadCocktailImages(for cocktails: Set<RandomCocktailOutput>) async throws -> [CocktailCard] {
        var cocktailCards: [CocktailCard] = []
        
        try await withThrowingTaskGroup(of: CocktailCard.self) { group in
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
    
}
