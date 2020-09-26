//
//  TopRedditProviderServiceTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import XCTest
@testable import iOSTestDeviget

class TopRedditProviderServiceTestCases: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetchTopReddit_callsRequesterFetch() {
        let requester = RequesterMock()
        let provider = DefaultTopRedditProviderService(requester: requester)
        provider.fetchTopReddit(using: nil,
                                completion: { _ in})
        XCTAssertTrue(requester.requestCalled)
    }
    
    func test_fetchTopReddit_cancelsPreviousRequest() {
        let requester = RequesterMock()
        let provider = DefaultTopRedditProviderService(requester: requester)
        provider.fetchTopReddit(using: nil,
                                completion: { _ in})
        let firstRequest = provider.currentTask as! CancellableRequestMock
        
        XCTAssertTrue(firstRequest.status == .inProgress)
        
        provider.fetchTopReddit(using: nil,
                                completion: { _ in})
        let secondRequest = provider.currentTask as! CancellableRequestMock
        
        XCTAssertTrue(firstRequest.status == .cancelled)
        XCTAssertTrue(secondRequest.status == .inProgress)
        XCTAssertTrue(requester.requestCalled)
    }
}
