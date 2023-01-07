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
    
    @Published var selectedAppliances: [SelectedAppliance] = []
    
//    @Published var choosenAppliances: [Appliance]?
    
    
    @Published var appliancesCountBadge: Int = 0
    
//    @EnvironmentObject var priceService: PriceService
    
//    self.priceService.fetchData(for_country: "es")
    
    let myLocalPriceService = PriceService()
//    myLocalPriceService.fetchData(for_country: "es")
    
        
    var totalCost: Float {
        

        print("> countTotalCost")
        var total: Float = 0.0
        
        if let dp: DayPrice = myLocalPriceService.dayPrice {
            
            
            
            for selAppliance in selectedAppliances {
                
                let price = ( dp.data[selAppliance.time_start] * Float(selAppliance.appliance.power) ) / 1000
                
                total += price
            }
            
            return total
            
        } else {
            return total
        }

        
        

        
    }
    
    
    
    func toggleApplianceLabel(applianceLabel: ApplianceLabel) {
//        log("\(appliancesCountBadge)")
        applianceLabel.isSelected.toggle()
        
        if (applianceLabel.isSelected){
            
            let time_start = Int.random(in: 0..<23)
            
            let selected = SelectedAppliance(time_start: time_start, time_end: time_start+1, appliance: applianceLabel.appliance)
            
            
            self.selectedAppliances.append(selected)
        } else {
//            self.selectedAppliances.remove(at: 0)
            self.selectedAppliances = self.selectedAppliances.filter { $0.appliance.name != applianceLabel.appliance.name }
        }
        
        appliancesCountBadge = selectedAppliances.count
    }
    
    
    func changeApplianceRunTime(appliance: Appliance, newStartTime: Int) {
        let idx: Int = selectedAppliances.firstIndex(where: {$0.appliance.name == appliance.name})!
        self.selectedAppliances[idx].time_start = newStartTime
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
