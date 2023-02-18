//
//  RequestError.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

enum RequestError: Error {
    case before // stupid workaround to make possible return errors before actual HTTP request TODO: eliminate this
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unexpectedHeaders
    case unknown
    
    var customMessage: String {
        switch self {
        case .before:
            return "Error happens before actual request" // TODO: eliminate this
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .unexpectedHeaders:
            return "Unexpected Headers"
        default:
            return "Unknown error"
        }
    }
}
