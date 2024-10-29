//
//  DataProviderRequest.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

struct ApiRequest<I, O> where I: Encodable, O: Decodable {
    var input: I?
    var path: String
    var method: HTTPMethod
    var bodyEncoding: BodyEncoding<I>
    var bodyDecoding: BodyDecoding<O>
}
