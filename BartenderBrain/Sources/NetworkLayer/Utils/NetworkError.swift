//
//  NetworkError.swift
//  BartenderBrain
//
//  Created by Federico Serraino on 29/10/24.
//

import Foundation

enum NetworkError: Error {
    case urlError(msg: String)
    case inputFormatError(msg: String)
    case outputFormatError(msg: String)
    case serviceError(msg: String)
    case unknownError(code: String)
    
    var localizedDescription: String {
        switch self {
        case .urlError(let msg):
            "Url error: \(msg)"
        case .inputFormatError(let msg):
            "Input format error: \(msg)"
        case .outputFormatError(let msg):
            "Output format error: \(msg)"
        case .serviceError(let msg):
            "Service error: \(msg)"
        case .unknownError(let code):
            "Unknown Error, code: \(code)"
        }
    }
    
    var codeError: String {
        switch self {
        case .urlError:
            "BR01"
        case .inputFormatError:
            "BR02"
        case .outputFormatError:
            "BR03"
        case .serviceError:
            "BR04"
        case .unknownError(let code):
            code
        }
    }
           
}
