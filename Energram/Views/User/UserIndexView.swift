//
//  UserIndexView.swift
//  Energram
//
//  Created by Alex Antipov on 22.02.2023.
//

import SwiftUI

struct UserIndexView: View {
    
    @EnvironmentObject private var userAuthState: UserAuthStateViewModel
    
    var body: some View {
        if (userAuthState.isAuthenticated) {
            UserProfileView()
        } else {
            UserLoginRegisterView()
        }
        
    }
}
