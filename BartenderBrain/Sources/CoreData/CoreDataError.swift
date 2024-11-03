//
//  CoreDataErrors.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 03/11/24.
//

import Foundation

enum CoreDataError: Error {
    case fetchCocktailIdsError
    case saveCocotailIds
    
    var localizedDescription: String {
        switch self {
        case .fetchCocktailIdsError:
            "Error trying fetchCocktailIdsError"
        case .saveCocotailIds:
            "Error trying saveCocotailIds"
        }
    }
}
