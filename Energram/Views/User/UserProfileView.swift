//
//  UserProfileView.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//

import Foundation
import SwiftUI


struct UserProfileView: View {
    
    
    //    private enum DisplayMode {
    //        case register, login, forgot
    //    }
    //
    //    @State private var displayMode: DisplayMode = .register
    //
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    
//                    if authData == nil {
//                        Text("WTF")
//                        UserLoginRegisterView()
//                    }
                    
                    
                    Group {
                        
                        
                        
                        Text("Profile").font(.headlineCustom)
                        
                        
                        
                        
                        
                        if let p = userData{
                            VStack(spacing: 1) {
                                
                                
                                
                                Text(p.email).font(.headlineCustom)
                                Text(p.id).monospaced()
                            }
                            
                        }
                        
                        Button("Toggglee") {
                            self.isPresented.toggle()
                        }
                        
                    }
                    
                    
                    Group {
                        
                        Spacer()
                        
                        Text("Some debug buttons...").font(.regularCustom)
                        
                        Button("Refresh Token"){
                            Task { await refreshToken() }
                        }
                        
                        Button("Get Secret Page"){
                            secretPageContent = nil
                            Task { await requestSecretPage() }
                        }
                        
                        Button("Logout"){
                            userData = nil
                            access_token = nil
                            UserService().eraseAuthData()
                        }
                    }
                    
                    if let s = secretPageContent {
                        Text("Secret message \(s.message)")
                    }
                    
                    if let t = access_token {
                        Text(t).font(.system(size: 12)).monospaced()
                    }
                    
                    
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .padding()
                .onAppear {
                    self.readFromSettings()
                    
//                    if authData == nil {self.isPresented = true}
                }
//                .sheet(isPresented: $isPresented, onDismiss: {
//                    print("Modal dismissed. State now: \(self.isPresented)")
//                  }) {
//                      UserLoginRegisterView()
//                  }
            }
        }
        
    }
    
    @FocusState private var focusedField: Field?
    
    @State private var isPresented: Bool = false
    
    //    @State private var input_email: String = "bob@energram.com"
    //    @State private var input_password: String = "bb7DMsMXAZE8"
    @State private var input_email: String = ""
    @State private var input_password: String = ""
    
    @State private var loading: Bool = false
    
    @State private var authData: AuthData?
    
    @State private var userData: User?
    @State private var secretPageContent: SecretPageResponse?
    
    @State private var access_token: String?
    
    private func readFromSettings() {
        self.access_token = SettingsManager.shared.getStringValue(name: "AccessToken")
        self.authData = UserService().readAuthData()
        
        print(authData)
    }
    
    private func requestLogin(username: String, password: String) async {
        loading = true
        Task(priority: .background) {
            let response = await UserService().requestLogin(username: username, password: password)
            switch response {
            case .success(let result):
                userData = result.user
                
                
                access_token = result.access_token
                
                UserService().saveAuthData(data: result)
                
                
                
                loading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                loading = false
            }
        }
    }
    
    private func refreshToken() async {
        loading = true
        Task(priority: .background) {
            let response = await UserService().useRefreshToken()
            switch response {
            case .success(let result):
                print(result)
                loading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                
                secretPageContent = SecretPageResponse(message: error.customMessage)
                loading = false
            }
        }
    }
    
    private func requestSecretPage() async {
        loading = true
        Task(priority: .background) {
            let response = await UserService().getSecretPage()
            switch response {
            case .success(let result):
                secretPageContent = result
                loading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                
                secretPageContent = SecretPageResponse(message: error.customMessage)
                loading = false
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

extension UserProfileView {
    private enum Field: Int, CaseIterable {
        case input_email, input_password
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .input_email
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .input_password
        }
    }
    
    private func canFocusPreviousField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue > 0
    }
    
    private func canFocusNextField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue < Field.allCases.count - 1
    }
}
