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

class SettingsManager {
    
    private let defaults = UserDefaults.standard
    private var settings: [SettingsItem] = [
        SettingsItem(name: "TestParameter", type: "Bool", defaultValue: true), // Used only in tests
        SettingsItem(name: "ShowDebugInfo", type: "Bool", defaultValue: true),
        SettingsItem(name: "CountryCode", type: "String", defaultValue: "es")
    ]
    
    
//    init(){
//
////        print("> SettingsManager Init")
////        print(UserDefaults.standard.dictionaryRepresentation())
//
//
//    }
        

    func createAndSaveDefault() {
        for item in self.settings {
            print("Writing default setting for \(item.name)")
            defaults.set(item.defaultValue, forKey: item.name)
        }
    }
    
    private func getSettingItem(withName: String) -> SettingsItem {
        let idx = self.settings.firstIndex(where: { $0.name == withName })!
        return self.settings[idx]
    }
    
    
//
//    private func getSettingItem(withName: String) -> SettingsItem {
//
//
//        if let idx = self.settings.firstIndex(where: { $0.name == withName }){
//            return self.settings[idx]
//        } else {
//            print("Writing default settings")
//            self.createAndSaveDefault()
//
//            let idx2 = self.settings.firstIndex(where: { $0.name == withName })!
//            return self.settings[idx2]
//
//        }
//
//
//
//
////        do {
////            let idx = try self.settings.firstIndex(where: { $0.name == withName })
////            return self.settings[idx]
////        }
////        catch {
////            print(error.localizedDescription)
////            self.createAndSaveDefault()
////            let idx = self.settings.firstIndex(where: { $0.name == withName })!
////            return self.settings[idx]
////        }
////
//
//
//
//    }
//
    public func getValue(name: String) -> Any {
        let item = getSettingItem(withName: name)
        switch item.type {
            case "Bool":
                return UserDefaults.standard.bool(forKey: item.name)
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
    
    
}
