//
//  DailyPlan.swift
//  Energram
//
//  Created by Alex Antipov on 05.02.2023.
//

import SwiftUI


struct Hour: Identifiable {
    var id: Int
    var price: Float
    var appliancesAssigned: [Appliance]
}


class DailyPlan: ObservableObject {
    
    @Published var hours: [Hour] = []
    
    
    //var priceService: PriceService?
    
    @Published var publishedvar: String = "p"
    
    //    init(dayPrice: DayPrice){
    //        print("> DailyPlan Init")
    //        for (index, price) in dayPrice.data.enumerated() {
    //            self.hours.append( Hour(id: index, price: price, appliancesAssigned: []) )
    //        }
    //
    //    }
    
//    func assingService(service: PriceService){
//        print("> assingService")
//        self.priceService = service
//
//    }
    
    func fillPrices(dayPrice: DayPrice){
        print("> DailyPlan fillPrices")
        for (index, price) in dayPrice.data.enumerated() {
            self.hours.append( Hour(id: index, price: price, appliancesAssigned: []) )
        }
        
    }
    
    func toggleApplianceLabel(applianceLabel: ApplianceLabel) {
        applianceLabel.isSelected.toggle()
        
//        if let service = priceService {
//            print("yes service")
//                    if let data = service.dayPrice {
//                        self.fillPrices(dayPrice: data)
//                        self.hours[0].appliancesAssigned.append(applianceLabel.appliance)
//                    } else {
//                        print("no prices data")
//                    }
//        } else {
//            print("no service")
//        }
        
//        if let data = priceService!.dayPrice {
//            self.fillPrices(dayPrice: data)
//        } else {
//            print("no prices data")
//        }
        
        
        publishedvar = "wow"
        print(publishedvar)
        
        if (applianceLabel.isSelected){
            
//            self.hours[0].appliancesAssigned.append(applianceLabel.appliance)
            
            
            
        }
        //        appliancesCountBadge = selectedAppliances.count
    }
    
    var allPricesArray: [Float] {
        var a: [Float] = []
        for i in hours {
            a.append(i.price)
        }
        return a
    }
    
    
    func addAppliance(appliance: Appliance) {
        print("> addAppliance")
        
        //        self.statevar = "s1"
        publishedvar = "p1"
        
        func get_index_of_minimal() -> Int? {
            if let idx: Int = self.hours.firstIndex(where: {$0.price == allPricesArray.min()}) {
                return idx
            }
            return nil
        }
        
        
        if let index_minimal = get_index_of_minimal() {
            self.hours[index_minimal].appliancesAssigned.append(appliance)
        }
        
        
        self.printPlan()
    }
    
    
    
    func printPlan() {
        print("> printPlan")
        for hour in hours {
            print("\(hour.id): \(hour.price) - \(hour.appliancesAssigned)")
        }
    }
    
    
}
