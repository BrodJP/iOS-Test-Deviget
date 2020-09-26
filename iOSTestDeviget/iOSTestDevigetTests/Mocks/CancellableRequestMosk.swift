//
//  CancellableRequestMosk.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation
@testable import iOSTestDeviget

class CancellableRequestMock: CancellableRequest {
    enum Status {
        case cancelled
        case inProgress
        case notInitiated
    }
    
    var status: Status = .notInitiated
    
    func cancel() {
        status = .cancelled
    }
    func resume() {
        status = .inProgress
    }
}
