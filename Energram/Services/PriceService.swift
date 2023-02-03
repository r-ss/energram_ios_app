//
//  PriceService.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI


struct Hour: Identifiable {
    var id: Int
    var price: Float
    var appliancesAssigned: [Appliance]
}


class DailyPlan {
    
    @State var hours: [Hour] = []
    
    @State var statevar: String = "s"
    @Published var publishedvar: String = "p"
    
    init(dayPrice: DayPrice){
        print("> DailyPlan Init")
        for (index, price) in dayPrice.data.enumerated() {
            self.hours.append( Hour(id: index, price: price, appliancesAssigned: []) )
        }

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
        
        self.statevar = "s1"
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


class PriceService: ObservableObject {
    
    @Published var dayPrice: DayPrice?
    @Published var dayPriceRAWJSON: String = "- no data -"
    
    @Published var multipleDaysPrices: [DayPrice]?
    
    var dailyPlan: DailyPlan?
    
    
    func fetchData(for_country: String){
        if let url = URL(string: Config.urlApi + "/price/" + for_country + "/latest") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withFullDate]
                    

                    decoder.dateDecodingStrategy = .custom({ decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        
                        if let date = formatter.date(from: dateString) {
                            return date
                        }
                        
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                    })
                    
                    if let safeData = data {
                        do {
                            let result = try decoder.decode(DayPrice.self, from: safeData)
                            DispatchQueue.main.async {
                                self.dayPrice = result
                                
                                self.dailyPlan = DailyPlan(dayPrice: result)
                                self.dayPriceRAWJSON = safeData.prettyPrintedJSONString!
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
    
    func fetchMultipleDaysData(for_country: String){
        
        let url = Config.urlApi + "/price/" + for_country + "/all"
        
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withFullDate]

                    decoder.dateDecodingStrategy = .custom({ decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        
                        if let date = formatter.date(from: dateString) {
                            return date
                        }
                        
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                    })
                    
                    if let safeData = data {
                        do {
                            let result = try decoder.decode([DayPrice].self, from: safeData)
                            DispatchQueue.main.async {
                                self.multipleDaysPrices = Array(result[0 ..< 10]) // Limiting result to 10
//                                self.dayPriceRAWJSON = safeData.prettyPrintedJSONString!
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
