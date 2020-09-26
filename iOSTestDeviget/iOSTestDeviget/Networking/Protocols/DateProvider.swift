//
//  DateProvider.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import Foundation

// Allows to mock Date for tests
protocol DateProvider {
    var timeIntervalSince1970: TimeInterval { get }
}

extension Date: DateProvider {}
