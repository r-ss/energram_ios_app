//
//  SettingsManagerTests.swift
//  EnergramTests
//
//  Created by Alex Antipov on 09.01.2023.
//

import XCTest
@testable import Energram

final class SettingsManagerTests: XCTestCase {

    /*
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    */

    func testSettingsSettingAndGetting() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let settingsManager = SettingsManager()
        
        
        settingsManager.setValue(name: "TestParameter", value: true)
        
        
        var param = settingsManager.getBoolValue(name: "TestParameter")
        XCTAssertEqual(param, true, "Param must be true")
        
        settingsManager.setValue(name: "TestParameter", value: false)
        
        param = settingsManager.getBoolValue(name: "TestParameter")
        
        XCTAssertEqual(param, false, "Param must be false")
        
        
        
        
    }

    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */

}
