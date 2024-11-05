//
//  BodyCoding.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

enum BodyEncoding<I: Encodable> {
    case json
    case custom(encode: (_ input: I) throws -> Data)
}

enum BodyDecoding<O: Decodable> {
    case json
    case custom(decode: (_ data: Data) throws -> O)
}
