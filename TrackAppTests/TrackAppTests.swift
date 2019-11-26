//
//  TrackAppTests.swift
//  TrackAppTests
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import XCTest
@testable import TrackApp

class TrackAppTests: XCTestCase {
  
  var viewModel: TrackDetailViewViewModel!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let trackRoute = TrackRoute()
    trackRoute.name = "name"
    trackRoute.duration = 0
    trackRoute.timestamp = Date()
    viewModel = TrackDetailViewViewModel(trackRoute: trackRoute)
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testName(){
    XCTAssertEqual(viewModel.name, "name")
  }
  
  func testDuration() {
    XCTAssertEqual(viewModel.duration, "0:00:00")
  }
  
  func testTimeStamp() {
    XCTAssertNotNil(viewModel.timestamp)
  }
  
}
