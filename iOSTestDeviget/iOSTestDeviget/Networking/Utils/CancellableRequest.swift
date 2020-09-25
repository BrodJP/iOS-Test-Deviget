//
//  CancellableRequest.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

protocol CancellableRequest {
    func cancel()
    func resume()
}

extension URLSessionDataTask: CancellableRequest {}
