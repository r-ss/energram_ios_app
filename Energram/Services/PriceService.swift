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
    
    
    func fetchData(){
        if let url = URL(string: Config.urlLatestPrice) {
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
                            let result = try decoder.decode(DayPriceResponse.self, from: safeData)
                            DispatchQueue.main.async {
                                self.dayPrice = result.content
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
    
    func fetchMultipleDaysData(){
        if let url = URL(string: Config.urlMultiplePrices) {
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
                            let result = try decoder.decode(MultipleDaysPriceResponse1.self, from: safeData)
                            DispatchQueue.main.async {
//                                print(result)
                                self.multipleDaysPrices = result.content.items.reversed()
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
