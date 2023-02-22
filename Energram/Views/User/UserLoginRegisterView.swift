//
//  UserLoginRegisterView.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//

import Foundation
import SwiftUI


struct UserLoginRegisterView: View {
    
    @EnvironmentObject private var userAuthState: UserAuthStateViewModel
    
    
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
                                Text("Having an account on Energram allows more personalized experience and services")
                            }
                            
                            if displayMode == .login {
                                Text("Login").font(.headlineCustom)
                            }
                            
                            if displayMode == .forgot {
                                Text("Reset password").font(.headlineCustom)
                                Text("Enter your email and get a code to change your password")
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
                                CommonPrimaryButton(title: "Send code", onClick:{
                                    Task { await requestPasswordReset(email: input_email) }
                                })
                                
                                
                                if passwordResetCodeWasSent {
                                    Spacer()
                                    Text("Code was sent. Please check email.")
                                }
                                
                                Spacer()
                                Button("Go back"){
                                    displayMode = .login
                                }
                            }
                            
                            if displayMode == .register {
                                CommonPrimaryButton(title: "Create account", onClick:{
                                    Task { await requestRegister(email: input_email, password: input_password) }
                                })
                                
                                Spacer()
                                
                                HStack {
                                    Text("Already have one?")
                                    Button("Login"){
                                        displayMode = .login
                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                            if displayMode == .login {
                               
                                CommonPrimaryButton(title: "Login", onClick:{
                                    Task { await requestLogin(email: input_email, password: input_password) }
                                })
                                
                                Spacer()
                                
                                
                                
                                Button("Forgot password?"){
                                    displayMode = .forgot
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text("Don't have an account?")
                                    Button("Register"){
                                        displayMode = .register
                                    }
                                }
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
//                        if let p = userData{
//                            VStack(spacing: 1) {
//
//
//
//                                Text(p.email).font(.headlineCustom)
//                                Text(p.id).monospaced()
//                            }
//
//                        }
                        
                    }
                    
                    
//                    Group {
//
//                        Spacer()
//
//                        Text("Some debug buttons...").font(.regularCustom)
//
//
//                        Button("Get Secret Page"){
//                            secretPageContent = nil
//                            Task { await requestSecretPage() }
//                        }
//
//
//                    }
                    
//
//                    if let s = secretPageContent {
//                        Text("Secret message \(s.message)")
//                    }
//
//                    if let t = access_token {
//                        Text(t).font(.system(size: 12)).monospaced()
//                    }
                    
                    
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
    
    @State private var passwordResetCodeWasSent: Bool = false
    
    private func requestLogin(email: String, password: String) async {
        loading = true
        Task(priority: .background) {
            let response = await UserService().requestLogin(email: email, password: password)
            switch response {
            case .success(let result):
                UserService().saveAuthData(data: result)
                userAuthState.checkAuth()
                loading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                loading = false
            }
        }
    }
    
    private func requestRegister(email: String, password: String) async {
        loading = true
        Task(priority: .background) {
            let response = await UserService().requestRegister(email: email, password: password)
            switch response {
            case .success(let _):
//                UserService().saveAuthData(data: result)
//                userStateViewModel.checkAuth()
                print("User registered, trying to login...")
                Task { await requestLogin(email: email, password: password) }
//                loading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                loading = false
            }
        }
    }
    
    private func requestPasswordReset(email: String) async {
        loading = true
        Task(priority: .background) {
            let response = await UserService().requestPasswordReset(email: email)
            switch response {
            case .success(let result):
                print(result)
                passwordResetCodeWasSent = true
                displayMode = .login
                loading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
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
