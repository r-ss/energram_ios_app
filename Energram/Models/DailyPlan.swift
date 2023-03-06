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
            
            let pricesBaked: [Float] = DayPrice.mocked.day1.data
            
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
    
    private func fillPrices(dayPrice: DayPrice){
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
    
    func applyTimeDiffAfterDrag(aa: AppliedAppliance, diffRecieved: Int?) {
        guard let diff = diffRecieved else {
            log("Received nil time diff")
            return
        }
        
        guard let newStart = Calendar.current.date(byAdding: .minute, value: diff, to: aa.start) else {
            log("Cannot apply diff")
            return
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: newStart)
        let hour = components.hour ?? 0
        //let minute = components.minute ?? 0
        
        //let midnight = Calendar.current.date(bySettingHour: 00, minute: 0, second: 0, of: Date())!
        
        var newcomponents = DateComponents()
        newcomponents.hour = hour
        newcomponents.minute = 0
        
        //let roundedToHour = Calendar.current.date(byAdding: newcomponents, to: midnight)!
        
        self.unassignAppliance(appliance: aa.appliance)
        self.assignAppliance(appliance: aa.appliance, toHour: hour)
        //        self.hours[hour].appliancesAssigned.append(appliance)
    }
    
    func changeApplianceRunTime(appliance: Appliance, newStartTime: Int) {
        self.unassignAppliance(appliance: appliance)
        self.hours[newStartTime].appliancesAssigned.append(appliance)
    }
    
    // MARK: Calculations
    
    func calculatePricexDuration(startHourIndex: Int, durationMinutes: Int, power: Int) -> Float {
        let pw: Float = Float(power) / 1000
        
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
                sum = sum + prices[startHourIndex + index] * pw
                lastCompleteHourIndex = index
            }
            sum = sum + ((prices[ lastCompleteHourIndex + 1] / 60) * Float(andMinutes)) * pw
        } else {
            sum = (prices[ startHourIndex ] / 60) * Float(andMinutes) * pw
        }
        return sum
    }
    
    func findMinimumPriceInDay(durationMinutes: Int, power: Int) -> (hour: Int, price: Float) {
        var minimumStartHour: Int = 0
        var minimumFound = calculatePricexDuration(startHourIndex: 0, durationMinutes: durationMinutes, power: power)
        
        let hours = durationMinutes / 60
        let andMinutes = durationMinutes % 60
        
        if hours > 0 {
            
            var minutesPadding = 0
            if andMinutes > 0 {
                minutesPadding = 1
            }
            
            
            for hour in 0...24-hours-minutesPadding {
                let candidate: Float = calculatePricexDuration(startHourIndex: hour, durationMinutes: durationMinutes, power: power)
                if candidate < minimumFound {
                    minimumFound = candidate
                    minimumStartHour = hour
                }
            }
        } else {
            for hour in 0..<24 {
                let candidate: Float = calculatePricexDuration(startHourIndex: hour, durationMinutes: durationMinutes, power: power)
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
    
    
    private func assignAppliance(appliance: Appliance, toHour: Int? = nil) {
        guard let _ = self.price else {
            log("Don't have a price data so ca't do anything")
            return
        }
        
        var timeslotIndex: Int = 0
        if let forcedHour = toHour {
            timeslotIndex = forcedHour
        } else {
            let minimum = findMinimumPriceInDay(durationMinutes: appliance.typical_duration, power: appliance.power)
            timeslotIndex = minimum.hour
        }
        
        self.hours[timeslotIndex].appliancesAssigned.append(appliance)
        let cost = calculatePricexDuration(startHourIndex: timeslotIndex, durationMinutes: appliance.typical_duration, power: appliance.power)
        self.appliedAppliances.add(appliance: appliance, hour: timeslotIndex, cost: cost)
    }
    
    private func unassignAppliance(appliance: Appliance) {
        for (index, hour) in self.hours.enumerated() {
            let filtered = hour.appliancesAssigned.filter(){$0.name != appliance.name}
            self.hours[index].appliancesAssigned = filtered
        }
        self.appliedAppliances.remove(appliance: appliance)
        //        self.printPlan()
    }
    
    
    func printPlan() {
        log("> printPlan")
        for hour in hours {
            log("\(hour.id): \(hour.price) - \(hour.appliancesAssigned.count) appliances, used power: \(hour.usedPower)")
        }
    }
    
}
