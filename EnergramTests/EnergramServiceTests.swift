//
//  EnergramServiceTests.swift
//  EnergramTests
//
//  Created by Alex Antipov on 18.02.2023.
//

import XCTest
@testable import Energram


final class EnergramServiceMock: Mockable, EnergramServiceable {
    func fetchLatestPrice(forCountry code: String) async -> Result<DayPrice, RequestError> {
        return .success(loadJSON(filename: "price_latest_response", type: DayPrice.self))
    }
    func fetchPrices(forCountry code: String) async -> Result<[DayPrice], RequestError> {
        return .success(loadJSON(filename: "price_all_response", type: [DayPrice].self))
    }
    func fetchAppliances() async -> Result<[Appliance], RequestError> {
        return .success(loadJSON(filename: "appliance_all_response", type: [Appliance].self))
    }
    func fetchApiInfo() async -> Result<String, RequestError> {
        return .success(loadJSON(filename: "info_response", type: String.self))
    }
}



final class EnergramService: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEnergramServiceLatestPriceMock() async {
        let serviceMock = EnergramServiceMock()
        let failingResult = await serviceMock.fetchLatestPrice(forCountry: "cz")
        
        switch failingResult {
        case .success(let result):
            //                XCTAssertEqual(result.id, "637d2673e18cc2a4bfd62869")
            XCTAssertEqual(result.data[4], 0.09255)
        case .failure:
            XCTFail("The request should not fail")
        }
    }
    
    func testEnergramServicePricesMock() async {
        let serviceMock = EnergramServiceMock()
        let failingResult = await serviceMock.fetchPrices(forCountry: "cz")
        
        switch failingResult {
        case .success(let result):
            //                XCTAssertEqual(result.id, "637d2673e18cc2a4bfd62869")
            XCTAssertEqual(result[0].data[0], 0.1157)
        case .failure:
            XCTFail("The request should not fail")
        }
    }
    
    
    func testEnergramServiceAppliancesMock() async {
        let serviceMock = EnergramServiceMock()
        let failingResult = await serviceMock.fetchAppliances()
        
        switch failingResult {
        case .success(let result):
            //                XCTAssertEqual(result.id, "637d2673e18cc2a4bfd62869")
            XCTAssertEqual(result[0].name, "Washing machine")
            XCTAssertEqual(result[0].power, 425)
            XCTAssertEqual(result[0].created_by, "637c82c257d3efaf9317ec32")
        case .failure:
            XCTFail("The request should not fail")
        }
    }
    
    
}
