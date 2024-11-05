//
//  CommunicationManager.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

class NetworkManager {
    
    func callService<I, O>(request apiRequest: ApiRequest<I, O>) async throws -> O {
        guard let url = URL(string: apiRequest.path) else {
            throw NetworkError.urlError(msg: "Invalid URL for api: \(apiRequest.path)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue
        
        if apiRequest.method != .GET, let input = apiRequest.input {
            do {
                switch apiRequest.bodyEncoding {
                case .json:
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    urlRequest.httpBody = try JSONEncoder().encode(input)
                case .custom(let encode):
                    urlRequest.httpBody = try encode(input)
                }
            } catch {
                throw NetworkError.inputFormatError(msg: "Invalid input format for api: \(apiRequest.path)")
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode > 199, httpResponse.statusCode < 300 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NetworkError.serviceError(msg: "Network error, status code \(statusCode) for api: \(apiRequest.path)")
        }
        
        let output: O
        do {
            switch apiRequest.bodyDecoding {
            case .json:
                output = try JSONDecoder().decode(O.self, from: data)
            case .custom(let decode):
                output = try decode(data)
            }
        } catch {
            throw NetworkError.outputFormatError(msg: "Invalid output format for api: \(apiRequest.path)")
        }
        
        return output
    }
    
}
