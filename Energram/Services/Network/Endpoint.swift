//
//  Endpoint.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

import Foundation

protocol Endpoint {
    var host: String { get }
//    var path: String { get }
    var urlComponents: URLComponents? { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

//extension Endpoint {
//    var host: String {
//        return "https://api.github.com"
//    }
//}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}
