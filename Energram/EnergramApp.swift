//
//  EnergramApp.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI

@main
struct EnergramApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var dataManager = DataManager.shared
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("Active")
            case .inactive:
                print("Inactive")
                dataManager.saveData()
            case .background:
                print("background")
                dataManager.saveData()
            default:
                print("unknown")
            }
        }
    }
}
