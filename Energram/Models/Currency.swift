//
//  Currency.swift
//  Energram
//
//  Created by Alex Antipov on 06.03.2023.
//

import Foundation



enum SelectedCurrency: String, CaseIterable, Identifiable {
    case eur, czk
    
    var id: String { self.rawValue }
    
    var tag: String {
        
        switch self {
        case .eur:
            return "EUR"
        case .czk:
            return "CZK"
        }
    }
    
    
}

class Currency: ObservableObject {
    
    static let shared = Currency()
    
    @Published var selectedCurrency: SelectedCurrency {
        didSet {
            print("selectedCurrency is now \(selectedCurrency)")
            self.saveToSettings()
            
            if selectedCurrency == .czk {
                self.updateCZKRate()
            }
        }
    }
    
    @Published var czkRate: Float = 20
    @Published var lastFetch: Date?
    
    var rate: Float {
        switch self.selectedCurrency {
        case .eur:
            return 1.0
        case .czk:
            return self.czkRate
        }
    }
    
    var symbol: String {
        switch self.selectedCurrency {
        case .eur:
            return "€"
        case .czk:
            return "Kč"
        }
    }
    
    var powerUsageNotation: String {
        switch self.selectedCurrency {
        case .eur:
            return "€/kWh"
        case .czk:
            return "Kč/kWh"
        }
    }
    
    
    // MARK: Init
    
    init() {
        
//        self.selectedCurrency = with
        
        let currencyPreferenceFromSettings: String = SettingsManager.shared.getStringValue(name: SettingsNames.selectedCurrency)
        
        print(currencyPreferenceFromSettings)
        
        switch currencyPreferenceFromSettings {
        case "czk":
            self.selectedCurrency = .czk
            self.czkRate = Float(SettingsManager.shared.getDoubleValue(name: SettingsNames.currencyLatestCZK))
            self.updateCZKRate()
        default:
            self.selectedCurrency = .eur
        }
        
        
        
        
    }
    
    private func updateCZKRate() {
        Task(priority: .background) {
            if let rateCZK = await CurrencyRateService().fetchLatestRateCZK() {
                print("Recieved CZK in Currency.swift")
                DispatchQueue.main.async {
                    self.czkRate = Float(rateCZK)
                }
                SettingsManager.shared.setValue(name: SettingsNames.currencyLatestCZK, value: rateCZK)
                Notification.fire(name: .latestCurrencyRatesRecieved)
            }
        }
    }
    
//    func change(to: SelectedCurrency) {
//        print("> change from \(self.selectedCurrency.rawValue) to \(to.rawValue)")
//
//        if to != self.selectedCurrency {
//            self.selectedCurrency = to
//            print(to.rawValue)
//            SettingsManager.shared.setValue(name: SettingsNames.selectedCurrency, value: to.rawValue)
//            Notification.fire(name: .latestCurrencyRatesRecieved)
//        } else {
//            log("change(to: SelectedCurrency) -- actually not changed")
//        }
//
//    }
    
    func saveToSettings() {
        print("> saveToSettings()")
        SettingsManager.shared.setValue(name: SettingsNames.selectedCurrency, value: self.selectedCurrency.rawValue)
        //Notification.fire(name: .currencySettingChanged)
    }
    
    
    // Notification.fire(name: .latestCurrencyRatesRecieved)
    
}
        
        
