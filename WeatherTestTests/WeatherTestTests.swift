//
//  WeatherTestTests.swift
//  WeatherTestTests
//
//  Created by Nicholas Piotrowski on 23/01/2018.
//  Copyright © 2018 Nicholas Piotrowski. All rights reserved.
//

import XCTest
@testable import WeatherTest

class WeatherTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherDataModel() {
        
        var WeatherDataModelTest: WeatherDataModel!
        WeatherDataModelTest = WeatherDataModel()
        
        let result = WeatherDataModelTest.updateWeatherIcon(condition: 100)
        
        XCTAssertEqual(result, "Thunderstorm Mini", "Icon string is wrong")

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
