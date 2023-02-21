//
//  UserLoginRegisterView.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//

import Foundation
import SwiftUI


struct UserLoginRegisterView: View {
    
    
    private enum DisplayMode {
        case register, login, forgot
    }
    
    @State private var displayMode: DisplayMode = .register
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    if loading {
                        
                        LoaderSpinner()
                        
                    } else {
                        
                        
                        Group {
                            
                            
                            if displayMode == .register {
                                Text("Create account").font(.headlineCustom)
                                Text("Having an account on Energram allows more personalized experience and services").font(.regularCustom)
                            }
                            
                            if displayMode == .login {
                                Text("Login").font(.headlineCustom)
                            }
                            
                            if displayMode == .forgot {
                                Text("Reset password").font(.headlineCustom)
                                Text("Enter your email and get a code to change your password").font(.regularCustom)
                            }
                            
                            
                            Spacer()
                            
                            TextField("Email", text: $input_email)
                                .focused($focusedField, equals: .input_email)
                                .onSubmit {
                                    focusNextField()
                                }
                                .submitLabel(.next)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .padding(3)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if displayMode != .forgot {
                                SecureField("Password", text: $input_password)
                                    .focused($focusedField, equals: .input_password)
                                    .onSubmit {
                                        focusNextField()
                                    }
                                    .submitLabel(.next)
                                    .padding(3)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                Button("Send code"){
                                    print("dfhg")
                                }
                                Spacer()
                                Button("Go back"){
                                    displayMode = .login
                                }
                            }
                            
                            if displayMode == .register {
                                Button("Create account"){
                                    print("dfhg")
                                }
                                
                                Spacer()
                                
                                Text("Already have one?").font(.regularCustom)
                                Button("Login"){
                                    displayMode = .login
                                }
                                
                            }
                            
                            if displayMode == .login {
                                Button("Login"){
                                    Task { await requestLogin(username: input_email, password: input_password) }
                                }
                                
                                Spacer()
                                
                                Button("Register"){
                                    displayMode = .register
                                }
                                
                                Button("Forgot password?"){
                                    displayMode = .forgot
                                }
                            }
                            
                            
                            
                        }
                        
                        
                        
                        if let p = userData{
                            VStack(spacing: 1) {
                                
                                
                                
                                Text(p.email).font(.headlineCustom)
                                Text(p.id).monospaced()
                            }
                            
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
//                .onAppear {
//                    self.readFromSettings()
//                }
            }
        }
        
    }
    
    @FocusState private var focusedField: Field?
    
    //    @State private var input_email: String = "bob@energram.com"
    //    @State private var input_password: String = "bb7DMsMXAZE8"
    @State private var input_email: String = ""
    @State private var input_password: String = ""
    
    @State private var loading: Bool = false
    
    @State private var userData: User?
    @State private var secretPageContent: SecretPageResponse?
    
    @State private var access_token: String?
    
//    private func readFromSettings() {
//        self.access_token = SettingsManager.shared.getStringValue(name: "AccessToken")
//    }
    
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

struct UserLoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginRegisterView()
    }
}

extension UserLoginRegisterView {
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
