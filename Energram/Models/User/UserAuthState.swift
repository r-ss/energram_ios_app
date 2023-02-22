//
//  UserState.swift
//  Energram
//
//  Created by Alex Antipov on 22.02.2023.
//

import Foundation

@MainActor
class UserAuthStateViewModel: ObservableObject {
    
    @Published var isAuthenticated = true
    
    func checkAuth(){
        if let _ = UserService().readAuthData() {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
    
//    func signIn(email: String, password: String) async -> Result<Bool, UserStateError>  {
//        isBusy = true
//        do{
//            try await Task.sleep(nanoseconds:  1_000_000_000)
//            isAuthenticated = true
//            isBusy = false
//            return .success(true)
//        }catch{
//            isBusy = false
//            return .failure(.signInError)
//        }
//    }
//
//    func signOut() async -> Result<Bool, UserStateError>  {
//        isBusy = true
//        do{
//            try await Task.sleep(nanoseconds: 1_000_000_000)
//            isAuthenticated = false
//            isBusy = false
//            return .success(true)
//        }catch{
//            isBusy = false
//            return .failure(.signOutError)
//        }
//    }
    
}
