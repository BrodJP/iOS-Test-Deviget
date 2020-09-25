//
//  DefaultRequesterTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import XCTest
@testable import iOSTestDeviget

struct MockModel: Decodable {
    let mockParam: String
}

struct MockEndpoint: Endpoint {
    var baseURL: URL = URL(string: "www.reddit.com")!
    
    var path: String = ""
    
    var httpMethod: HTTPMethod = .get
    
    var task: HTTPTask = .requestWithParameters(urlParameters: nil, encoder: .urlEncoding)
}

class DefaultRequesterTestCases: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_successfulDataTask_given_validDecodableModel() {
        let dataTaskFactory = URLSessionDataTaskFactoryMock()
        let requester = DefaultRequester(dataTaskFactory: dataTaskFactory)
        let expectedValue = "MockValue"
        let string = "{\"mockParam\": \"\(expectedValue)\"}"
        let data = string.data(using: .utf8)!
        dataTaskFactory.stubData = data
        dataTaskFactory.stubStatusCode = 200
        
        let expectation = XCTestExpectation(description: "Decoding MockModel")
        
        let completion: (Result<MockModel, Error>) -> Void = { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model.mockParam, expectedValue)
            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        requester.request(MockEndpoint(),
                          completion: completion)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_failureDataTask_given_invalidDecodableModel() {
        let dataTaskFactory = URLSessionDataTaskFactoryMock()
        let requester = DefaultRequester(dataTaskFactory: dataTaskFactory)
        let expectedValue = "MockValue"
        let string = "{\"mock_Param\": \"\(expectedValue)\"}"
        let data = string.data(using: .utf8)!
        dataTaskFactory.stubData = data
        dataTaskFactory.stubStatusCode = 200
        
        let expectation = XCTestExpectation(description: "Decoding MockModel")
        
        let completion: (Result<MockModel, Error>) -> Void = { result in
            switch result {
            case .success:
                XCTAssert(false, "Expected to get a failure")
            case .failure:
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        
        requester.request(MockEndpoint(),
                          completion: completion)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_failureDataTask_given_invalidStatusCode() {
        let dataTaskFactory = URLSessionDataTaskFactoryMock()
        let requester = DefaultRequester(dataTaskFactory: dataTaskFactory)
        let expectedValue = "MockValue"
        let string = "{\"mockParam\": \"\(expectedValue)\"}"
        let data = string.data(using: .utf8)!
        dataTaskFactory.stubData = data
        dataTaskFactory.stubStatusCode = 500
        
        let expectation = XCTestExpectation(description: "Decoding MockModel")
        
        let completion: (Result<MockModel, Error>) -> Void = { result in
            switch result {
            case .success:
                XCTAssert(false, "Expected to get a failure")
            case .failure:
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        
        requester.request(MockEndpoint(),
                          completion: completion)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
