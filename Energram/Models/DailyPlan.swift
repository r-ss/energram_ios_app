//
//  DailyPlan.swift
//  Energram
//
//  Created by Alex Antipov on 05.02.2023.
//

import Foundation
import SwiftUI


struct Hour: Identifiable, Hashable {
    var uid: UUID = UUID()
    var id: Int
    var price: Float
    var appliancesAssigned: [Appliance]
    var cheapIndex: Int? // sort hours by price and fill this value to calculate cell color in view
    
    var usedPower: Int {
        return self.appliancesAssigned.reduce(0, { $0 + $1.power })
    }
}



enum DailyPlanType {
    case normal, preview
}



class DailyPlan: ObservableObject {
    
    @Published var hours: [Hour] = []
    @Published var price: DayPrice?
    //@Published var appliances: [Appliance]?
    
    @Published var lastFetch: Date?
    
    @Published var appliedAppliances = AppliedAppliances()
    
    @Published var appliancesListViewModel = AppliancesListViewModel()
    
    
    @Published var selectedApplianceToEdit: Appliance?
    
    // MARK: Init
    
    init(type: DailyPlanType = .normal) {
        
        
        
        switch type {
        case .normal:
            appliancesListViewModel.fetchAppliances()
            //self.appliances = appliancesListViewModel.appliances
            
        case .preview:
            //self.appliances = [Appliance.mocked.appliance1, Appliance.mocked.appliance2]
            self.appliedAppliances.items = [AppliedAppliance.mocked.aa1, AppliedAppliance.mocked.aa2, AppliedAppliance.mocked.aa3, AppliedAppliance.mocked.aa4, AppliedAppliance.mocked.aa5]
            
            let pricesBaked: [Float] = [
                0.10724,
                0.10465,
                0.10397,
                0.1056,
                0.10361,
                0.10448,
                0.10385,
                0.10782,
                0.11107,
                0.10924,
                0.10661,
                0.11204,
                0.10965,
                0.11058,
                0.10933,
                0.11464,
                0.13467,
                0.14514,
                0.16633,
                0.17132,
                0.1622,
                0.15324,
                0.14495,
                0.13524
            ]
            
            for i in 0..<23 {
                let newHour = Hour(id: i, price: pricesBaked[i], appliancesAssigned: [])
                self.hours.append(newHour)
            }
            
            let sortedByPrice:[Hour] = hours.sorted {
                $0.price < $1.price
            }
            
            for (index, hour) in sortedByPrice.enumerated() {
                if let idx: Int = self.hours.firstIndex(where: {$0.uid == hour.uid}) {
                    self.hours[idx].cheapIndex = index
                }
            }
            
            
        }
    }
        
        
        
    
    func priceReceived(price data:DayPrice) {
        self.price = data
        self.fillPrices(dayPrice: data)
        
        self.lastFetch = Date()
        Notification.fire(name: .latestPriceRecieved)
    }
    
//    func appliancesReceived(appliances: [Appliance]) {
//        self.appliances = appliances
//    }
    
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
    
    func getAppliancebyId(_ str: String) -> Appliance? {
        let uuid = UUID(uuidString: str)
        
//        guard let appliances = self.appliancesListViewModel.appliances else {
//            print("Optional appliances are nil")
//            return nil
//        }
        
        if let idx: Int = self.appliancesListViewModel.appliances.firstIndex(where: {$0.id == uuid}) {
            return self.appliancesListViewModel.appliances[idx]
        }
        
        print("Can't find apliance with requested uuid")
        return nil
    }
    
    func isApplianceApplied(_ appliance: Appliance) -> Bool {
        
        if let _: Int = self.appliedAppliances.items.firstIndex(where: {$0.appliance.id == appliance.id}) {
            return true
        }
        return false
        
        
    }
    
    func applianceModified(appliance: Appliance) {
//        print(appliance)
        self.unassignAppliance(appliance: appliance)
        self.assignAppliance(appliance: appliance)
    }
    
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
    
    func calculatePricexDuration(startHourIndex: Int, durationMinutes: Int) -> Float {
        
        guard let prices: [Float] = self.price?.data else {
            print("Error in set prices in DailyPlan.swift")
            return 0
        }
        
        var sum: Float = 0

        let hours = durationMinutes / 60
        let andMinutes = durationMinutes % 60
        
        var lastCompleteHourIndex: Int = startHourIndex
        if hours > 0 {
            for index in 0..<hours {
                sum = sum + prices[startHourIndex + index]
                lastCompleteHourIndex = index
            }
            sum = sum + (prices[ lastCompleteHourIndex + 1] / 60) * Float(andMinutes)
        } else {
            sum = (prices[ startHourIndex ] / 60) * Float(andMinutes)
        }
        return sum
    }

    func findMinimumPriceInDay(durationMinutes: Int) -> (hour: Int, price: Float) {
        var minimumStartHour: Int = 4
        var minimumFound = calculatePricexDuration(startHourIndex: 0, durationMinutes: durationMinutes)
        
        let hours = durationMinutes / 60
        //let andMinutes = durationMinutes % 60
        
        if hours > 0 {
            for hour in 0...24-hours {
                let candidate: Float = calculatePricexDuration(startHourIndex: hour, durationMinutes: durationMinutes)
                if candidate < minimumFound {
                    minimumFound = candidate
                    minimumStartHour = hour
                }
            }
        } else {
            for hour in 0..<24 {
                let candidate: Float = calculatePricexDuration(startHourIndex: hour, durationMinutes: durationMinutes)
                if candidate < minimumFound {
                    minimumFound = candidate
                    minimumStartHour = hour
                }
                
            }
            
        }
        return (hour: minimumStartHour, price: minimumFound)
    }
    
    
    
    
    private var allPricesArray: [Float] {
        var a: [Float] = []
        for i in hours {
            a.append(i.price)
        }
        return a
    }
    
    private func chooseTimeslot(forAppliance appliance: Appliance) -> Int {
        //log("> chooseTimeslot")
        
//        let userReservedPower: Int = SettingsManager.shared.getIntegerValue(name: SettingsNames.reservedPower)
        
//        let sortedByPrice:[Hour] = hours.sorted { $0.price < $1.price}
//        let sortedByPriceAndFiltered:[Hour] = sortedByPrice.filter(){$0.usedPower <= userReservedPower}
        
        
        
        
        
        
        let minimum = findMinimumPriceInDay(durationMinutes: appliance.typical_duration)
        return minimum.hour


        
//        func calculatePricexDuration(startHourIndex: Int, duration: Int) -> Float {
//            var sum: Float = 0
////            print(self.price!.data)
//            for index in (0...duration-1) {
//                sum = sum + prices[startHourIndex + index]
//            }
//            return sum
//        }
//
//        var minimumStartHour: Int = 0
//        var minimumFound = calculatePricexDuration(startHourIndex: 0, duration: duration)
//
//        for index in (0...24-duration) {
//            let candidate: Float = calculatePricexDuration(startHourIndex: index, duration: duration)
//        //    minimumFound = min(minimumFound.price, .price)
//
//            if candidate < minimumFound {
//                minimumFound = candidate
//                minimumStartHour = index
//            }
//
//        }
//        return minimumStartHour
        
//        for (_, hour) in sortedByPriceAndFiltered.enumerated() {
//            if hour.usedPower < appliance.power {
//                if let idx: Int = self.hours.firstIndex(where: {$0.uid == hour.uid}) {
//                    return idx
//                }
//            }
//            //            return 0
//        }
        
//        log("Error, cannot find time slot for appliance")
//        return 0
    }
    
    
    private func assignAppliance(appliance: Appliance) {
        //log("> assignAppliance")
        let timeslotIndex = chooseTimeslot(forAppliance: appliance)
        self.hours[timeslotIndex].appliancesAssigned.append(appliance)
        
        let cost = calculatePricexDuration(startHourIndex: timeslotIndex, durationMinutes: appliance.typical_duration)
        
        self.appliedAppliances.add(appliance: appliance, hour: timeslotIndex, cost: cost)
        
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
