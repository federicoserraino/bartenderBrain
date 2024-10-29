//
//  RandomConcktailApiCatalog.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

class RandomCocktailApiCatalog: ApiCatalog {
    typealias I = CodableVoid
    typealias O = RandomCocktailOutput
    
    static var path: String { "https://www.thecocktaildb.com/api/json/v1/1/random.php" }
    static var method: HTTPMethod { .GET }
    static var bodyEncoding: BodyEncoding<I> { .json }
    static var bodyDecoding: BodyDecoding<O> { .json }
    
}

struct RandomCocktailOutput: Decodable {
    let id: String
    let thumbUrl: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var drinksArray = try container.nestedUnkeyedContainer(forKey: .drinks)
        let firstDrink = try drinksArray.nestedContainer(keyedBy: DrinkKeys.self)
        self.id = try firstDrink.decode(String.self, forKey: .idDrink)
        self.thumbUrl = try firstDrink.decode(String.self, forKey: .strDrinkThumb)
    }
    
    private enum CodingKeys: String, CodingKey {
        case drinks
    }
    
    private enum DrinkKeys: String, CodingKey {
        case idDrink
        case strDrinkThumb
    }
}
