//
//  Config.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation

struct Config {
    
    static let urlWeb: String = "https://energram.ress.ws"
    static let urlApi: String = "https://energram-api.ress.ws"
    
    static let urlApiInfo: String = urlApi + "/info"
    static let urlLatestPrice: String = urlApi + "/price/latest"
    static let urlMultiplePrices: String = urlApi + "/price/all"
    
}
