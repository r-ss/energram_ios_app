

import Foundation



protocol EnergramServiceable {
    func fetchLatestPrice(forCountry code: String) async -> Result<DayPrice, RequestError>
    func fetchPrices(forCountry code: String) async -> Result<[DayPrice], RequestError>
    func fetchAppliances() async -> Result<[Appliance], RequestError>
    func fetchApiInfo() async -> Result<String, RequestError>
}



struct EnergramService: HTTPClient, EnergramServiceable {
    
    func fetchApiInfo() async -> Result<String, RequestError> {
        return await getPrettyPrintedJSONResponse(endpoint: EnergramEndpoint.apiInfo)
    }
    
    func fetchLatestPrice(forCountry code: String) async -> Result<DayPrice, RequestError> {
        return await sendRequest(endpoint: EnergramEndpoint.latestPriceForCountry(countryCode: code), responseModel: DayPrice.self)
    }
    
    func fetchPrices(forCountry code: String) async -> Result<[DayPrice], RequestError> {
        return await sendRequest(endpoint: EnergramEndpoint.pricesForCountry(countryCode: code), responseModel: [DayPrice].self)
    }
    
    func fetchAppliances() async -> Result<[Appliance], RequestError> {
        return await sendRequest(endpoint: EnergramEndpoint.appliances, responseModel: [Appliance].self)
    }
    
    
}
