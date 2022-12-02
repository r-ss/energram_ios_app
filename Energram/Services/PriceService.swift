//
//  PriceService.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI


class PriceService: ObservableObject {
    
    @Published var dayPrice: DayPrice?
    @Published var dayPriceRAWJSON: String = "- no data -"
    
    @Published var multipleDaysPrices: [DayPrice]?
    
    
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
                                self.multipleDaysPrices = result.reversed()
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
    
}
