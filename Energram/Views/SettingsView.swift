//
//  SettingsView.swift
//  Energram
//
//  Created by Alex Antipov on 08.01.2023.
//

import Foundation

import SwiftUI

struct SettingsView: View {
    
    
    let settingsManager = SettingsManager()
    
    @State private var showDebugInfo: Bool = true
    @State private var userReservedPower: Int = 4
    
    
    func readSettings() {
        self.showDebugInfo = settingsManager.getBoolValue(name: "ShowDebugInfo")
        self.userReservedPower = settingsManager.getIntegerValue(name: "ReservedPower")
    }
    
    @State private var country_code_from_settings = "none"
    @State private var selection = "Spain"
    let countries = ["Spain", "Czech"]
    

    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Settings").font(.headlineCustom).padding(.bottom)
                
              
                
                //                Button("Delete all cards", action: { self.deleteAllCardsConfirmationShown = true }).foregroundColor(.red)
                //                Button("Add baked cards", action: { self.addBakedCards() })
                //                Button("Remove baked cards", action: { self.removeBakedCards() })
                
                Text("Select a country:").font(.regularCustom)
                Picker("Select a country", selection: $selection) {
                    ForEach(countries, id: \.self) {
                        Text($0).font(.regularCustom)
                    }
                }
                //.pickerStyle(.menu)
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selection) { item in
                    
                    print("Picked item: \(item)")
                    
                    if item == "Spain" {
                        settingsManager.setValue(name: "CountryCode", value: "es")
                    }
                    
                    if item == "Czech" {
                        settingsManager.setValue(name: "CountryCode", value: "cz")
                    }
                    
                }
                
                Text("Reserved Power: \(userReservedPower)")
                
                //Text("Selected country: \(selection)")
                //Text("country_code_from_settings: \(country_code_from_settings)")
                
                
                
                
                Toggle("Show Debug Info", isOn: $showDebugInfo)
                    .onChange(of: showDebugInfo) { value in
                        settingsManager.setValue(name: "ShowDebugInfo", value: value)
                    }.font(.regularCustom)
                
                
                if showDebugInfo {
                    DebugView()
                }
                
            }
            .onAppear {
                self.readSettings()
                
                
                
                
                let country_code = settingsManager.getStringValue(name: "CountryCode")
                
                self.country_code_from_settings = country_code
                
                if country_code == "es" {
                    self.selection = "Spain"
                }
                
                if country_code == "cz" {
                    self.selection = "Czech"
                }
                
            }
            .padding()
            .frame(width: geometry.size.width, alignment: .leading)
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
