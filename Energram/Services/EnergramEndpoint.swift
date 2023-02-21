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
    
    case userLogin//(username: String, password: String)
    case secretPage
    case refreshToken
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
            
        case .userLogin, .refreshToken:
            return URLComponents(string: "\(self.host)/token")
        case .secretPage:
            return URLComponents(string: "\(self.host)/secretpage")
        }
    }
    
    var host: String {
        return "https://api.energram.co"
        //return "http://127.0.0.1:8000"
    }
    
    
    var method: RequestMethod {
        switch self {
        case .userLogin:
            return .post
        case .refreshToken:
            return .patch
        default:
            return .get
        }
    }
    
    var header: [String: String]? {
        // Access Token to use in Bearer header
        var accessToken: String? = nil
        
        if let authData = UserService().readAuthData() {
            accessToken = authData.access_token
        }
        
        switch self {
        case .userLogin, .refreshToken:
            return nil
        default:
            if accessToken == nil {
                return nil
            }
            return ["Authorization": "Bearer \(accessToken ?? "--not present--")", "Content-Type": "application/json;charset=utf-8"]
        }
    }
    
    var body: [String: String]? {
        switch self {
            //        case .userLogin(let username, let password):
            //            return ["username": username, "password": password]
            
        case .refreshToken:
            guard let authData = UserService().readAuthData() else {
                log("> Can't get authData in EnergramEndpoint.swift, this should not happens")
                return nil
            }
            return ["refresh_token": authData.refresh_token]
        default:
            return nil
        }
    }
}


