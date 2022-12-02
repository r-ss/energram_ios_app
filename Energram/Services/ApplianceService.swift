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
//                                print(result)
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
