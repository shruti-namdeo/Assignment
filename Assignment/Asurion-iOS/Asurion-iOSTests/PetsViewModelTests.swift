//
//  PetsViewModelTests.swift
//  Asurion-iOSTests
//
//  Created by Shrey Shrivastava on 21/06/22.
//  Copyright © 2022 Shruti. All rights reserved.
//

import XCTest
@testable import Asurion_iOS

class PetsViewModelTests: XCTestCase {
    var viewModel: PetsLogic!
    
    override func setUp() {
        self.viewModel = MockPetsLogic.init()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewModel = nil
    }
    
    func testPetsData(){
        viewModel.getPetsData { (result) in
            switch result{
            case .success( let pets):
                XCTAssertNotNil(pets)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
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

}
