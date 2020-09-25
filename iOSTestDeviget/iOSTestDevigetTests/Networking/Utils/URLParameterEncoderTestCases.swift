//
//  URLParameterEncoderTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import XCTest
@testable import iOSTestDeviget

class URLParameterEncoderTestCases: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_correctParamEncoding() throws {
        let parameterEncoder = URLParameterEncoder()
        var request = URLRequest(url: URL(string: "www.reddit.com")!)
        
        let mockKey = "KEY"
        let mockValue = "VALUE"
        
        let parameters = [mockKey: mockValue]
        
        try parameterEncoder.encode(urlRequest: &request, with: parameters)
        
        XCTAssertEqual(request.url?.absoluteString, "www.reddit.com?KEY=VALUE")
    }
}
