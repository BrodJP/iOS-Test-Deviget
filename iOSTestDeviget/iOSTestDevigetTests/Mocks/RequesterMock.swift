//
//  RequesterMock.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import Foundation
@testable import iOSTestDeviget

class RequesterMock: Requester {
    
    var requestCalled: Bool = false
    
    func request<T: Decodable>(_ endpoint: Endpoint,
                               completion: @escaping (Result<T, Error>) -> Void)  -> CancellableRequest? {
        requestCalled = true
        let request = CancellableRequestMock()
        request.resume()
        return request
    }
}
