//
//  GithubEndpoints.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

import Foundation

enum EnergramEndpoint {
    case apiInfo
    case pricesForCountry(countryCode: String)
    case latestPriceForCountry(countryCode: String)
    case appliances
}

extension EnergramEndpoint: Endpoint {
    
    
    var urlComponents: URLComponents? {
        switch self {
        case .apiInfo:
            return URLComponents(string: "\(self.host)/info")
        case .pricesForCountry(let countryCode):
            return URLComponents(string: "\(self.host)/price/\(countryCode)/all")
        case .latestPriceForCountry(let countryCode):
            return URLComponents(string: "\(self.host)/price/\(countryCode)/latest")
        case .appliances:
            return URLComponents(string: "\(self.host)/appliance/all")
        }
    }
    
    var host: String {
        return "https://api.energram.co"
    }
    
    
    var method: RequestMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var header: [String: String]? {
        // Access Token to use in Bearer header
        //        let accessToken = "insert your access token here -> https://www.themoviedb.org/settings/api"
        switch self {
        default:
            return nil
            //            return [
            //                "Authorization": "Bearer \(accessToken)",
            //                "Content-Type": "application/json;charset=utf-8"
            //            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
}


