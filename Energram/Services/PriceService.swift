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
    
    func fetchData(){
        if let url = URL(string: Config.urlLatestPrice) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let result = try decoder.decode(DayPriceResponse.self, from: safeData)
                            DispatchQueue.main.async {
                                self.dayPrice = result.content
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
