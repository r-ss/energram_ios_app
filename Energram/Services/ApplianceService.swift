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
//    @Published var appliancesCountBadge: Int = 0
    
    @EnvironmentObject var priceService: PriceService
    
//    @Published var dailyPlan: DailyPlan?
    
    
    
    func toggleApplianceLabel(applianceLabel: ApplianceLabel, priceService: PriceService) {
        applianceLabel.isSelected.toggle()
        
        if (applianceLabel.isSelected){
            
            
                        priceService.dailyPlan?.addAppliance(appliance: applianceLabel.appliance)
            
            //            let time_start = Int.random(in: 0..<23)
            
            //            let time_start: Int = proposeApplianceRunningTime(selectedAppliances: selectedAppliances, newAppliance: applianceLabel.appliance, priceService: priceService)
            
            //            let selected = SelectedAppliance(time_start: time_start, time_end: time_start+1, appliance: applianceLabel.appliance)
            
            
            //            self.selectedAppliances.append(selected)
            //        } else {
            //            self.selectedAppliances = self.selectedAppliances.filter { $0.appliance.name != applianceLabel.appliance.name }
            //        }
        }
//        appliancesCountBadge = selectedAppliances.count
    }
    
    
    func changeApplianceRunTime(appliance: Appliance, newStartTime: Int) {
        let idx: Int = selectedAppliances.firstIndex(where: {$0.appliance.name == appliance.name})!
        self.selectedAppliances[idx].time_start = newStartTime
    }
    
    func proposeApplianceRunningTime(selectedAppliances: [SelectedAppliance], newAppliance: Appliance, priceService: PriceService) -> Int {
        
//        print(selectedAppliances)
        
//        let prices: [Float] = priceService.dayPrice.data
//
//
////        for price in prices {
//
//
//
//
//        func get_index_of_minimal() -> Int {
//            let idx: Int = priceService.dayPrice.data.firstIndex(where: {$0 == prices.min()})!
//            return idx
//        }
//
        
        
        
        
        
        
        
//        let index_minimal = get_index_of_minimal()
        
//        for (index, price) in prices.enumerated() {
//
//            if index_minimal == index {
//                print("\(index): \(price) <<")
//            } else {
//                print("\(index): \(price)")
//            }
//
//        }
        
        if let plan = priceService.dailyPlan {
            plan.printPlan()
        }
        
        return 1
        
        
        
//        return(index_minimal)
        
        
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
