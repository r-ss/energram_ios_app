//
//  ApplianceService.swift
//  Energram
//
//  Created by Alex Antipov on 01.12.2022.
//

import Foundation

import Foundation
import SwiftUI


class ApplianceService: ObservableObject {
   
    
    @Published var appliances: [Appliance]?
    
    @Published var selectedAppliances: [Appliance] = []
    
//    @Published var choosenAppliances: [Appliance]?
    
    
    @Published var appliancesCountBadge: Int = 0
    
    
    
    
    func toggleApplianceLabel(applianceLabel: ApplianceLabel) {
//        log("\(appliancesCountBadge)")
        applianceLabel.isSelected.toggle()
        
        if (applianceLabel.isSelected){
            self.selectedAppliances.append(applianceLabel.appliance)
        } else {
//            self.selectedAppliances.remove(at: 0)
            self.selectedAppliances = self.selectedAppliances.filter { $0.name != applianceLabel.appliance.name }
        }
        
        appliancesCountBadge = selectedAppliances.count
    }
    
        
    func fetchAppliancesData(){
        if let url = URL(string: Config.appliencesListURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    
//                    let formatter = ISO8601DateFormatter()
//                    formatter.formatOptions = [.withFullDate]
//
//                    decoder.dateDecodingStrategy = .custom({ decoder in
//                        let container = try decoder.singleValueContainer()
//                        let dateString = try container.decode(String.self)
//
//                        if let date = formatter.date(from: dateString) {
//                            return date
//                        }
//
//                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
//                    })
                    
                    if let safeData = data {
                        
                        do {
                            let result = try decoder.decode([Appliance].self, from: safeData)
                            
                            
                            DispatchQueue.main.async {
                                self.appliances = result
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
