//
//  TestVideoViewModel.swift
//  QueenBeeRVTests
//
//  Created by Stephen Walton on 8/17/23.
//

import XCTest
@testable import QueenBeeRV

final class TestVideoViewModel: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // We know this fetches in batches of 10
    func testFetchLatestVideos() async {
        let videoVM = VideoViewModel()
        
        await videoVM.fetchLatestVideos()
        
        XCTAssertEqual(videoVM.latestVideos?.items.count, 10)
    }
    
    func testFetchPlaylists() async {
        let videoVM = VideoViewModel()
        
        await videoVM.fetchPlaylists()
        
        XCTAssertNotNil(videoVM.allPlaylists)
        if let count = videoVM.allPlaylists?.items.count {
            XCTAssertGreaterThan(count, 0)
        }
    }
}
