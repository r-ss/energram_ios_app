//
//  UserProfileView.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//

import Foundation
import SwiftUI


struct UserProfileView: View {
    
    @EnvironmentObject private var userAuthState: UserAuthStateViewModel
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                                       
                    Group {
                        Text("Profile").font(.headlineCustom)
                        
                        if let p = authData{
                            VStack(spacing: 1) {
                                Text(p.email).font(.headlineCustom)
                                Text(p.id).monospaced()
                            }
                        }
                        
                        Spacer()
                        
                        UserpicView().frame(width:150, height: 150)
                        
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
                            secretPageContent = nil
                            authData = nil
                            UserService().eraseAuthData()
                            userAuthState.checkAuth()
                        }
                    }
                    
                    if let s = secretPageContent {
                        Text("Secret message \(s.message)")
                    }
                    
                    if let t = authData?.access_token {
                        Text(t).font(.system(size: 12)).monospaced()
                    }
                    
                    
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .padding()
                .onAppear {
                    self.readFromSettings()
                    
//                    if let id = authData?.id {
//                        Task { await self.requestUserProfileFromBackend(id: id)}
//                    }
                }
//                .sheet(isPresented: $isPresented, onDismiss: {
//                    print("Modal dismissed. State now: \(self.isPresented)")
//                  }) {
//                      UserLoginRegisterView()
//                  }
            }
        }
        
    }
    

//    @State private var isPresented: Bool = false
    
    //    @State private var input_email: String = "bob@energram.com"
    //    @State private var input_password: String = "bb7DMsMXAZE8"
    @State private var input_email: String = ""
    @State private var input_password: String = ""
    
    @State private var loading: Bool = false
    
    @State private var authData: AuthData?
    
    @State private var secretPageContent: SecretPageResponse?
    
    private func readFromSettings() {
        self.authData = UserService().readAuthData()

    }
        
    private func refreshToken() async {
        loading = true
        Task(priority: .background) {
            let response = await UserService().useRefreshToken()
            switch response {
            case .success(let result):
                UserService().saveFreshRefreshTokens(tokens: result)
                loading = false
                readFromSettings()
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
