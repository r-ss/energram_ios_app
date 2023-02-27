//
//  CurrencyRateService.swift
//  Energram
//
//  Created by Alex Antipov on 27.02.2023.
//

import Foundation


struct CurrencyRateResponse: Decodable {
    var success: Bool
    var base: String
    //var date: String
    var rates: [String: Double]
}



enum CurrencyRateEndpoint {
    case latest

}

extension CurrencyRateEndpoint: Endpoint {
    
    var urlComponents: URLComponents? {
        switch self {
        case .latest:
            return URLComponents(string: "\(self.host)/latest")
        }
        
    }
    
    var host: String {
        return "https://api.exchangerate.host"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var header: [String: String]? {
        return nil
    }
    
    var body: [String: String]? {
        return nil
    }
}

protocol CurrencyRateServiceable {
    func fetchLatestRates() async -> Result<CurrencyRateResponse, RequestError>
}


struct CurrencyRateService: HTTPClient, CurrencyRateServiceable {
    
    func fetchLatestRates() async -> Result<CurrencyRateResponse, RequestError> {
        return await sendRequest(endpoint: CurrencyRateEndpoint.latest, responseModel: CurrencyRateResponse.self)
    }
    
    func fetchLatestRateCZK() async -> Double? {
        
        //Task(priority: .background) {
            let response = await self.fetchLatestRates()
            switch response {
            case .success(let result):
//                currencyRates = result
//                print(result)
                
                return result.rates["CZK"]
                //return 6.666
//                currencyRatesLoading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
//                currencyRatesLoading = false
                return nil
            }
        //}
        
    }
    
}
