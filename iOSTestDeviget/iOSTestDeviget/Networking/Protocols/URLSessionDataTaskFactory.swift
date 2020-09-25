//
//  URLSessionDataTaskFactory.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

// Will allow mocking URLSession for Unit Tests
protocol URLSessionDataTaskFactory {
    func cancellableDataTask(with request: URLRequest,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> CancellableRequest
    func cancellableDataTask(with url: URL,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> CancellableRequest
}

extension URLSession: URLSessionDataTaskFactory {
    func cancellableDataTask(with request: URLRequest,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> CancellableRequest {
        return dataTask(with: request, completionHandler: completionHandler)
    }
    
    func cancellableDataTask(with url: URL,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> CancellableRequest {
        return dataTask(with: url, completionHandler: completionHandler)
    }
}
