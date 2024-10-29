//
//  NetworkProvier.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

protocol NetworkProvier: AnyObject {
    func getRandomCocktail() async throws -> RandomCocktailOutput
    func getCocktailImageData(from url: String) async throws -> Data
}

class AppNetworkProvier: NetworkProvier {
    
    private init() {}
    static let shared = AppNetworkProvier()
    private let networkManager = NetworkManager()
    
    func getRandomCocktail() async throws -> RandomCocktailOutput {
        let request = RandomCocktailApiCatalog.request()
        let output = try await networkManager.callService(request: request)
        return output
    }
    
    func getCocktailImageData(from url: String) async throws -> Data {
        var request = CocktailImageApiCatalog.request()
        request.path = url
        let output = try await networkManager.callService(request: request)
        return output
    }
    
}
