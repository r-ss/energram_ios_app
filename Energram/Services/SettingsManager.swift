//
//  SettingsManager.swift
//  Energram
//
//  Created by Alex Antipov on 08.01.2023.
//

import Foundation


struct SettingsItem {
    var name: String
    var type: String
    var defaultValue: Any
}

struct SettingsManager {
    
    
    static let shared = SettingsManager()
    
    //    private init() { }
    
    
    private let defaults = UserDefaults.standard
    private var settings: [SettingsItem] = [
        SettingsItem(name: "TestParameter", type: "Bool", defaultValue: true), // Used only in tests
        SettingsItem(name: "Existence", type: "Bool", defaultValue: true), // Used to determine existence of settings and writing default values routine if not
        SettingsItem(name: "ShowDebugInfo", type: "Bool", defaultValue: false),
        SettingsItem(name: "CountryCode", type: "String", defaultValue: "es"),
        SettingsItem(name: "ReservedPower", type: "Integer", defaultValue: 4600), // Watts
    ]
    
    
    private init(){
        //print("> SettingsManager's privete Init")
        if UserDefaults.standard.object(forKey: "Existence") == nil {
            self.createAndSaveDefault()
        }
    }
    
    
    func createAndSaveDefault() {
        defaults.set(25, forKey: "Age")
        
        for item in self.settings {
            print("Writing default setting for \(item.name)")
            defaults.set(item.defaultValue, forKey: item.name)
        }
    }
    
    private func getSettingItem(withName: String) -> SettingsItem {
        let idx = self.settings.firstIndex(where: { $0.name == withName })!
        return self.settings[idx]
    }
    
    
    public func getValue(name: String) -> Any {
        let item = getSettingItem(withName: name)
        switch item.type {
        case "Bool":
            return UserDefaults.standard.bool(forKey: item.name)
        case "Integer":
            return UserDefaults.standard.integer(forKey: item.name)
        default:
            // in other cases we assume String
            return UserDefaults.standard.string(forKey: item.name)!
        }
    }
    
    public func setValue(name: String, value: Any) {
        let item = getSettingItem(withName: name)
        defaults.set(value, forKey: item.name)
    }
    
    public func getStringValue(name: String) -> String {
        let item = getSettingItem(withName: name)
        if let param = UserDefaults.standard.string(forKey: item.name) {
            return param
        } else {
            return item.defaultValue as! String
        }
        
    }
    
    public func getBoolValue(name: String) -> Bool {
        //        print("> getBoolValue for \(name)")
        let item = getSettingItem(withName: name)
        return UserDefaults.standard.bool(forKey: item.name)
        
        //        if let param = UserDefaults.standard.bool(forKey: item.name) {
        //            return param
        //        } else {
        //            return item.defaultValue as! Bool
        //        }
    }
    
    public func getIntegerValue(name: String) -> Int {
        //        print("> getBoolValue for \(name)")
        let item = getSettingItem(withName: name)
        return UserDefaults.standard.integer(forKey: item.name)
    }
    
    
}
