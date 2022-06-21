//
//  DetectWorkingHourTests.swift
//  Asurion-iOSTests
//
//  Created by Shrey Shrivastava on 20/06/22.
//  Copyright © 2022 Shruti. All rights reserved.
//

import XCTest
@testable import Asurion_iOS

let kSchedule = "M-F 10:00 - 18:00"
class DetectWorkingHourTests: XCTestCase {
    var workingHourViewModel: WorkingHourViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        workingHourViewModel = WorkingHourViewModel.init(schedule: kSchedule)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_detectWorkingHoursViewModel() throws {
        let alertString = self.workingHourViewModel.isCurrentDateTimeWithinWorkingHours()
        XCTAssertEqual(alertString, AlertMessage.isWithinWorkingHours.rawValue)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
