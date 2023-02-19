//
//  DailyPlan.swift
//  Energram
//
//  Created by Alex Antipov on 05.02.2023.
//

import SwiftUI


struct Hour: Identifiable {
    var uid: UUID = UUID()
    var id: Int
    var price: Float
    var appliancesAssigned: [Appliance]
    
    var usedPower: Int {
        return self.appliancesAssigned.reduce(0, { $0 + $1.power })
    }
}


class DailyPlan: ObservableObject {
    
    @Published var hours: [Hour] = []
    @Published var price: DayPrice?
    @Published var appliances: [Appliance]?
    
    // MARK: Init
    
    func priceReceived(price data:DayPrice) {
        self.price = data
        self.fillPrices(dayPrice: data)
    }
    
    func appliancesReceived(appliances data:[Appliance]) {
        self.appliances = data
    }
    
    private func fillPrices(dayPrice: DayPrice){
        log("> DailyPlan fillPrices")
        for (index, price) in dayPrice.data.enumerated() {
            self.hours.append( Hour(id: index, price: price, appliancesAssigned: []) )
        }
        
    }
    
    // MARK: Interaction
    
    func toggleApplianceLabel(applianceLabel: ApplianceLabel) {
        applianceLabel.isSelected.toggle()
        if (applianceLabel.isSelected){
            self.assignAppliance(appliance: applianceLabel.appliance)
        } else {
            self.unassignAppliance(appliance: applianceLabel.appliance)
        }
    }
    
    func changeApplianceRunTime(appliance: Appliance, newStartTime: Int) {
        log("> changeApplianceRunTime")
        self.unassignAppliance(appliance: appliance)
        self.hours[newStartTime].appliancesAssigned.append(appliance)
    }
    
    // MARK: Calculations
    
    private var allPricesArray: [Float] {
        var a: [Float] = []
        for i in hours {
            a.append(i.price)
        }
        return a
    }
    
    private func chooseTimeslot(forAppliance appliance: Appliance) -> Int {
        log("> chooseTimeslot")
        
        let userReservedPower: Int = SettingsManager.shared.getIntegerValue(name: "ReservedPower")
        
        let sortedByPrice:[Hour] = hours.sorted { $0.price < $1.price}
        let sortedByPriceAndFiltered:[Hour] = sortedByPrice.filter(){$0.usedPower <= userReservedPower}
        
        for (_, hour) in sortedByPriceAndFiltered.enumerated() {
            if hour.usedPower < appliance.power {
                if let idx: Int = self.hours.firstIndex(where: {$0.uid == hour.uid}) {
                    return idx
                }
            }
        }
                
        log("Error, cannot find time slot for appliance")
        return 0
    }
    
    
    private func assignAppliance(appliance: Appliance) {
        log("> assignAppliance")
        let timeslotIndex = chooseTimeslot(forAppliance: appliance)
        self.hours[timeslotIndex].appliancesAssigned.append(appliance)
        
        self.printPlan()
    }
    
    private func unassignAppliance(appliance: Appliance) {
        log("> unassignAppliance")
        for (index, hour) in self.hours.enumerated() {
            let filtered = hour.appliancesAssigned.filter(){$0.name != appliance.name}
            self.hours[index].appliancesAssigned = filtered
        }
        
        self.printPlan()
    }
    
    
    func printPlan() {
        log("> printPlan")
        
        var sortedByPrice:[Hour] = hours.sorted {
            $0.price < $1.price
        }
        
        for hour in sortedByPrice {
            log("\(hour.id): \(hour.price) - \(hour.appliancesAssigned.count) appliances, used power: \(hour.usedPower)")
        }
    }
    
}
