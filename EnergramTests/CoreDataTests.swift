//
//  CoreDataTests.swift
//  EnergramTests
//
//  Created by Alex Antipov on 04.03.2023.
//

import XCTest
@testable import Energram

final class CoreDataTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    var dataManager: DataManager!

    override func setUp() {
        super.setUp()
        dataManager = DataManager.testing
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_a_Starts_Empty() {
        let appliances = dataManager.appliances
        
//        print("--------------")
//        print(appliances)
//        print("--------------")
        
        XCTAssertEqual(appliances.count, 0)
    }
    
    func test_b_Add_Appliance() {
        let appliance = Appliance(name: "My Test Device", typical_duration: 60, power: 100, createdAt: Date())
        dataManager.updateAndSave(appliance: appliance)
        
//        print("ZZZ --------------")
////        print(dataManager.appliances[0].value)
//        print(type(of: dataManager.appliances.values[0].name))
//        print("ZZZ --------------")
        
        XCTAssertEqual(dataManager.appliances.count, 1)
        XCTAssertEqual(dataManager.appliances.values[0].name, "My Test Device")
    }

}
