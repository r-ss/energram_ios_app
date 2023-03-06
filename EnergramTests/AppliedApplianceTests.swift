//
//  AppliedApplianceTests.swift
//  EnergramTests
//
//  Created by Alex Antipov on 05.03.2023.
//

import XCTest
@testable import Energram

final class AppliedApplianceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAAExample() throws {
        
        let aa = AppliedAppliance.mocked.aa1
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: aa.start)
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        
        XCTAssertEqual(day, 5)
        XCTAssertEqual(hour, 10)
        XCTAssertEqual(minute, 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
