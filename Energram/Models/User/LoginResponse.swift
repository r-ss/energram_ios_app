//
//  LoginResponse.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//

import Foundation

struct LoginResponse: Decodable {
    var auth: Bool
    var user: User
    var access_token: String
    var refresh_token: String
    var token_type: String
    
}

struct RefreshTokenResponse: Decodable {
    var access_token: String
    var refresh_token: String
}

struct ForgottenPasswordResetRequestResponse: Decodable {
    var result: Bool
}
