//
//  SettingsView.swift
//  Energram
//
//  Created by Alex Antipov on 08.01.2023.
//

import Foundation

import SwiftUI

struct SettingsView: View {
    
    //@State private var showDebugInfo: Bool = false
    //@State private var userReservedPower: Int = 0
    
    //    @State private var country_code_from_settings = "none"
    
    /// Settings
    @State private var showDebugInfo: Bool = false
    @State private var countryCode: String = "es"
    @State private var selectedCurrency: String = "EUR"
    @State private var currencyLatestCZK: Double = 23.0
    @State private var userReservedPower: Int = 4600
    
    private let countriesReadable = ["Spain", "Czech Republic"]
    @State private var countryPickerSelection = "Spain"
    
    private let currenciesReadable = ["EUR", "CZK"]
    @State private var currencyPickerSelection = "EUR"
    
    
    
    
    
    
    //    @AppStorage("ReservedPower") var userReservedPower: Int = 4600
    
    private func changeCountry(readable: String) {
        
        
        if readable == "Spain" {
            print("Set country in settings to: es")
            SettingsManager.shared.setValue(name: SettingsNames.countryCode, value: "es")
            //            self.countryCode = "es"
            self.changeCurrency(to: "EUR") // Force chagne to EUR if not Czech Rep.
//            currencyPickerSelection = "EUR"
        }
        
        if readable == "Czech Republic" {
            print("Set country in settings to: cz")
            SettingsManager.shared.setValue(name: SettingsNames.countryCode, value: "cz")
            //            self.countryCode = "cz"
            self.changeCurrency(to: "CZK")
//            currencyPickerSelection = "CZK"
        }
        
        Notification.fire(name: .countrySettingChanged)
        
    }
    
    private func changeCurrency(to: String) {
        print("Set currency in settings to:", to)
        //        self.currencyPickerSelection = to
        //        self.currency = to
        
        if selectedCurrency != to {
            SettingsManager.shared.setValue(name: SettingsNames.selectedCurrency, value: to)
            Notification.fire(name: .currencySettingChanged)
        }
        
        
        
        if currencyPickerSelection != to {
            currencyPickerSelection = to
        }
        
    }
    
    
    private func readSettings() {
        self.showDebugInfo = SettingsManager.shared.getBoolValue(name: SettingsNames.showDebugInfo)
        self.countryCode = SettingsManager.shared.getStringValue(name: SettingsNames.countryCode)
        self.selectedCurrency = SettingsManager.shared.getStringValue(name: SettingsNames.selectedCurrency)
        self.currencyLatestCZK = SettingsManager.shared.getDoubleValue(name: SettingsNames.currencyLatestCZK)
        self.userReservedPower = SettingsManager.shared.getIntegerValue(name: SettingsNames.reservedPower)
    }
    
    
    private func submitReservedPower() {
        SettingsManager.shared.setValue(name: SettingsNames.reservedPower, value: userReservedPower)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Settings").font(.headlineCustom).padding(.bottom)
                
                
                /// COUNTRY
                Text("Select a country:").font(.regularCustom)
                Picker("Select a country", selection: $countryPickerSelection) {
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
                    Picker("Select a currency", selection: $currencyPickerSelection) {
                        ForEach(currenciesReadable, id: \.self) {
                            Text($0).font(.regularCustom)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: currencyPickerSelection) { currencyName in
                        //print("Picked currency: \(currencyName)")
                        changeCurrency(to: currencyName)
                    }
                }
                
                /// RATES
                if currencyPickerSelection == "CZK" {
                    Text("1 EUR = \(currencyLatestCZK) CZK")
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
            .onAppear {
                self.readSettings()
                
                if countryCode == "es" {
                    self.countryPickerSelection = "Spain"
                }
                if countryCode == "cz" {
                    self.countryPickerSelection = "Czech Republic"
                }
                self.currencyPickerSelection = selectedCurrency
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
