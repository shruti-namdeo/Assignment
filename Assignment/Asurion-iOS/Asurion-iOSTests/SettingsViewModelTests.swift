//
//  SettingsViewModelTests.swift
//  Asurion-iOSTests
//
//  Copyright © 2022 Shruti. All rights reserved.
//

import XCTest
@testable import Asurion_iOS

class SettingsViewModelTests: XCTestCase {
    var viewModel: SettingsLogic!
    
    override func setUp() {
        let apiCall = MockSettingsAPICall.init()
        self.viewModel = SettingsViewModel.init(networkLayer: apiCall)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_getSettingsData() {
        
    }
    
}
