//
//  CocktailImageApiCatalog.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

class CocktailImageApiCatalog: ApiCatalog {
    typealias I = CodableVoid
    typealias O = Data
    
    static var path: String { "" } // Will be determined at run time
    static var method: HTTPMethod { .GET }
    static var bodyEncoding: BodyEncoding<I> { .json }
    static var bodyDecoding: BodyDecoding<O> { .custom(decode: { $0 }) }
}
