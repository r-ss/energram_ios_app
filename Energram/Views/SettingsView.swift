//
//  SettingsView.swift
//  Energram
//
//  Created by Alex Antipov on 08.01.2023.
//

import Foundation

import SwiftUI





struct SettingsView: View {
    
    /// Settings
    @State private var showDebugInfo: Bool = false
    @State private var countryCode: String = "es"
    @State private var userReservedPower: Int = 4600
    
    private let countriesReadable = ["Spain", "Czech Republic"]
    @State private var countryPickerSelection = "Spain"
    
    
    
    @ObservedObject var currency: Currency
    
    
    private func changeCountry(readable: String) {
        
        
        if readable == "Spain" {
            print("Set country in settings to: es")
            SettingsManager.shared.setValue(name: SettingsNames.countryCode, value: "es")
            currency.selectedCurrency = .eur
        }
        
        if readable == "Czech Republic" {
            print("Set country in settings to: cz")
            SettingsManager.shared.setValue(name: SettingsNames.countryCode, value: "cz")
            currency.selectedCurrency = .czk
        }
        
        Notification.fire(name: .countrySettingChanged)
    }
    
    private func readSettings() {
        self.showDebugInfo = SettingsManager.shared.getBoolValue(name: SettingsNames.showDebugInfo)
        self.countryCode = SettingsManager.shared.getStringValue(name: SettingsNames.countryCode)
        self.userReservedPower = SettingsManager.shared.getIntegerValue(name: SettingsNames.reservedPower)
    }
    
    private func submitReservedPower() {
        SettingsManager.shared.setValue(name: SettingsNames.reservedPower, value: userReservedPower)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Settings").font(.headlineCustom).padding(.bottom)
                
                //Text("Currency: \(currency.symbol)")
                
                /// COUNTRY
                Text("Select a country:").font(.regularCustom)
                Picker("Select a country", selection: $countryPickerSelection.animation(.spring())) {
                    ForEach(countriesReadable, id: \.self) {
                        Text($0).font(.regularCustom)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: countryPickerSelection) { countryReadable in
                    //print("Picked country: \(countryReadable)")
                    changeCountry(readable: countryReadable)
                }
                
                /// CURRENCY
                if countryPickerSelection == "Czech Republic" {
                    Picker("Select a currency", selection: $currency.selectedCurrency.animation(.spring())) {
                        
                        ForEach(SelectedCurrency.allCases, id: \.self) { selection in
                            Text(selection.tag)//.tag(flavor)
                        }
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                /// RATES
                if currency.selectedCurrency == .czk {
                    Text("1 EUR = \(currency.rate) \(currency.symbol)")
                }
                
                /// RESERVED POWER
                Group{
                    Text("Your Reserved Power (Watts):")
                    TextField("Reserved Power:", value: $userReservedPower, formatter: NumberFormatter())
                        .onSubmit {
                            submitReservedPower()
                        }.font(.headlineCustom)
                        .padding(3)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                /// DEBUG
                if Config.enableDebugUI {
                    Group {
                        Toggle("Show Debug Info", isOn: $showDebugInfo)
                            .onChange(of: showDebugInfo) { value in
                                showDebugInfo.toggle()
                                SettingsManager.shared.setValue(name: SettingsNames.showDebugInfo, value: showDebugInfo)
                            }.font(.regularCustom)
                        if showDebugInfo {
                            DebugView()
                        }
                    }
                }
            }
            .onAppear {
                self.readSettings()
                
                if countryCode == "es" {
                    self.countryPickerSelection = "Spain"
                }
                if countryCode == "cz" {
                    self.countryPickerSelection = "Czech Republic"
                }
            }
            .padding()
            .frame(width: geometry.size.width, alignment: .leading)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(currency: Currency())
    }
}
