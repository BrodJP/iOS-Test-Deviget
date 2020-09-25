//
//  URLSessionDataTaskFactoryMock.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation
@testable import iOSTestDeviget

class URLSessionDataTaskFactoryMock: URLSessionDataTaskFactory {
    var dataTaskForRequestCalled: Bool = false
    var dataTaskForURLCalled: Bool = false
    var stubData: Data?
    var stubError: Error?
    var stubStatusCode: Int = 200
    
    func cancellableDataTask(with request: URLRequest,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> CancellableRequest {
        dataTaskForRequestCalled = true
        let mockResponse = HTTPURLResponse(url: URL(string: "www.reddint.com")!,
                                           statusCode: stubStatusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
        completionHandler(stubData, mockResponse, stubError)
        return CancellableRequestMock()
    }
    
    func cancellableDataTask(with url: URL,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> CancellableRequest {
        dataTaskForURLCalled = true
        let mockResponse = HTTPURLResponse(url: URL(string: "www.reddint.com")!,
                                           statusCode: stubStatusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
        completionHandler(stubData, mockResponse, stubError)
        return CancellableRequestMock()
    }
}
