//
//  ParameterEncoderTypeTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import XCTest
@testable import iOSTestDeviget

class ParameterEncoderTypeTestCases: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_urlEncoding_encodesUrlParameters() throws {
        let encoderType = ParameterEncoderType.urlEncoding
        
        var request = URLRequest(url: URL(string: "www.reddit.com")!)
        
        let mockKey = "KEY"
        let mockValue = "VALUE"
        
        let parameters = [mockKey: mockValue]
        
        try encoderType.encode(urlRequest: &request, parameters: parameters)
        
        XCTAssertEqual(request.url?.absoluteString, "www.reddit.com?KEY=VALUE")
    }
}
