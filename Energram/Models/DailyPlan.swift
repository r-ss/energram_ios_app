//
//  DailyPlan.swift
//  Energram
//
//  Created by Alex Antipov on 05.02.2023.
//

import Foundation
import SwiftUI


struct Hour: Identifiable {
    var uid: UUID = UUID()
    var id: Int
    var price: Float
    var appliancesAssigned: [Appliance]
    var cheapIndex: Int? // sort hours by price and fill this value to calculate cell color in view
    
    var usedPower: Int {
        return self.appliancesAssigned.reduce(0, { $0 + $1.power })
    }
}




struct AppliedAppliance: Identifiable, Hashable {

    /* Struct used in labels that selects which appliances will be used during the day */

    var id: UUID = UUID()
    var start: Date
    var duration: Int
    
//    var time_end: Int
    var appliance: Appliance
}

// MARK: Mocked Data

extension AppliedAppliance {
    struct Mocked {
        var aa1: AppliedAppliance
        init() {
            
            func dateFromISOString(_ isoString: String) -> Date? {
                let isoDateFormatter = ISO8601DateFormatter()
                return isoDateFormatter.date(from: isoString)  // returns nil, if isoString is malformed.
            }
            


            
            let d = dateFromISOString("2023-03-05T20:10:56Z")
//            print("===============")
//
//            print("===============")
            self.aa1 = AppliedAppliance(start: d!, duration: 120, appliance: Appliance.mocked.appliance1)
        }
    }

    static var mocked: Mocked {
        Mocked()
    }
}

class AppliedAppliances: ObservableObject {
    
    @Published var items: [AppliedAppliance] = []
    
    func add(appliance: Appliance, hour: Int) {
        let aa = AppliedAppliance(start: Date(), duration: appliance.typical_duration, appliance: appliance)
        self.items.append(aa)
    }
    
    func remove(appliance: Appliance) {
        items = items.filter(){$0.appliance.id != appliance.id}
    }
}



class DailyPlan: ObservableObject {
    
    @Published var hours: [Hour] = []
    @Published var price: DayPrice?
    @Published var appliances: [Appliance]?
    
    @Published var lastFetch: Date?
    
    @Published var appliedAppliances = AppliedAppliances()
    
    
    @Published var selectedApplianceToEdit: Appliance?
    
    // MARK: Init
    
    func priceReceived(price data:DayPrice) {
        self.price = data
        self.fillPrices(dayPrice: data)
        
        self.lastFetch = Date()
        Notification.fire(name: .latestPriceRecieved)
    }
    
    func appliancesReceived(appliances data:[Appliance]) {
        self.appliances = data
    }
    
    private func fillPrices(dayPrice: DayPrice){
//        log("> DailyPlan fillPrices")

        self.hours = []
        
        for (index, price) in dayPrice.data.enumerated() {
            self.hours.append( Hour(id: index, price: price, appliancesAssigned: []) )
        }
        
        // Filling cheapIndexes
        let sortedByPrice:[Hour] = hours.sorted {
            $0.price < $1.price
        }
        
        for (index, hour) in sortedByPrice.enumerated() {
            if let idx: Int = self.hours.firstIndex(where: {$0.uid == hour.uid}) {
                self.hours[idx].cheapIndex = index
            }
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
        //log("> changeApplianceRunTime")
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
        //log("> chooseTimeslot")
        
        let userReservedPower: Int = SettingsManager.shared.getIntegerValue(name: SettingsNames.reservedPower)
        
        let sortedByPrice:[Hour] = hours.sorted { $0.price < $1.price}
        let sortedByPriceAndFiltered:[Hour] = sortedByPrice.filter(){$0.usedPower <= userReservedPower}
        
        for (_, hour) in sortedByPriceAndFiltered.enumerated() {
            if hour.usedPower < appliance.power {
                if let idx: Int = self.hours.firstIndex(where: {$0.uid == hour.uid}) {
                    return idx
                }
            }
            //            return 0
        }
        
        log("Error, cannot find time slot for appliance")
        return 0
    }
    
    
    private func assignAppliance(appliance: Appliance) {
        //log("> assignAppliance")
        let timeslotIndex = chooseTimeslot(forAppliance: appliance)
        self.hours[timeslotIndex].appliancesAssigned.append(appliance)
        
        let aa = AppliedAppliance(start: Date(), duration: appliance.typical_duration, appliance: appliance)
        self.appliedAppliances.add(appliance: appliance, hour: timeslotIndex)
        
        //self.printPlan()
    }
    
    private func unassignAppliance(appliance: Appliance) {
        //log("> unassignAppliance")
        for (index, hour) in self.hours.enumerated() {
            let filtered = hour.appliancesAssigned.filter(){$0.name != appliance.name}
            self.hours[index].appliancesAssigned = filtered
        }
        
        self.appliedAppliances.remove(appliance: appliance)
        
        //self.printPlan()
    }
    
    
    func printPlan() {
        log("> printPlan")
        
        //        var sortedByPrice:[Hour] = hours.sorted {
        //            $0.price < $1.price
        //        }
        
        for hour in hours {
            log("\(hour.id): \(hour.price) - \(hour.appliancesAssigned.count) appliances, cheapIndex: \(hour.cheapIndex ?? -1) used power: \(hour.usedPower)")
        }
    }
    
}
