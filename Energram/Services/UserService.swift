//
//  UserService.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//

import Foundation


struct SecretPageResponse: Codable {
    var message: String
}

protocol UserServiceable {
    func requestLogin(username: String, password: String) async -> Result<LoginResponse, RequestError>
    func useRefreshToken() async -> Result<RefreshTokenResponse, RequestError>
    func getSecretPage() async -> Result<SecretPageResponse, RequestError>
}

struct UserService: HTTPClient, UserServiceable {
    
    func requestLogin(username: String, password: String) async -> Result<LoginResponse, RequestError> {
        return await sendMultipartFormAuthRequest(endpoint: EnergramEndpoint.userLogin, username: username, password:password, responseModel: LoginResponse.self)
    }
    
    func useRefreshToken() async -> Result<RefreshTokenResponse, RequestError> {
        return await sendRequest(endpoint: EnergramEndpoint.refreshToken, responseModel: RefreshTokenResponse.self)
    }
    
    func getSecretPage() async -> Result<SecretPageResponse, RequestError> {
        return await sendRequest(endpoint: EnergramEndpoint.secretPage, responseModel: SecretPageResponse.self)
    }
    
    
    func saveAuthData(data: LoginResponse) {
        let authData = AuthData(id: data.user.id, email: data.user.email, access_token: data.access_token, refresh_token: data.refresh_token)
        SettingsManager.shared.setValue(name: "UserEmail", value: authData.email)
        SettingsManager.shared.setValue(name: "UserId", value: authData.id)
        SettingsManager.shared.setValue(name: "AccessToken", value: authData.access_token)
        SettingsManager.shared.setValue(name: "RefreshToken", value: authData.refresh_token)
    }
    
    func saveFreshRefreshTokens(tokens: RefreshTokenResponse) {
        SettingsManager.shared.setValue(name: "AccessToken", value: tokens.access_token)
        SettingsManager.shared.setValue(name: "RefreshToken", value: tokens.refresh_token)
    }
    
    func readAuthData() -> AuthData? {
        let email: String = SettingsManager.shared.getStringValue(name: "UserEmail")
        let id: String = SettingsManager.shared.getStringValue(name: "UserId")
        let access_token: String = SettingsManager.shared.getStringValue(name: "AccessToken")
        let refresh_token: String = SettingsManager.shared.getStringValue(name: "RefreshToken")
        
        if [id, email, access_token, refresh_token].allSatisfy({ $0.isEmpty == false }){
            //print("all not empty, good")
            return AuthData(id: id, email: email, access_token: access_token, refresh_token: refresh_token)
        }else{
            //print("all empty, bad")
            return nil
        }
    }
    
    func eraseAuthData() {
        SettingsManager.shared.setValue(name: "UserEmail", value: "")
        SettingsManager.shared.setValue(name: "UserId", value: "")
        SettingsManager.shared.setValue(name: "AccessToken", value: "")
        SettingsManager.shared.setValue(name: "RefreshToken", value: "")
    }
    
    
}
