//
//  ApiCatalog.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

protocol ApiCatalog: AnyObject {
    associatedtype I: Encodable
    associatedtype O: Decodable
    
    static var path: String { get }
    static var method: HTTPMethod { get }
    static var bodyEncoding: BodyEncoding<I> { get }
    static var bodyDecoding: BodyDecoding<O> { get }
    
    static func request(for input: I?) -> ApiRequest<I, O>
}

extension ApiCatalog {
    static func request(for input: I? = nil) -> ApiRequest<I, O> {
        .init(
            input: input,
            path: path,
            method: method,
            bodyEncoding: bodyEncoding,
            bodyDecoding: bodyDecoding
        )
    }
}
