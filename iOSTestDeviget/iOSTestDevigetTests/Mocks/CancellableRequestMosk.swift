//
//  CancellableRequestMosk.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation
@testable import iOSTestDeviget

class CancellableRequestMock: CancellableRequest {
    func cancel() {}
    func resume() {}
}
