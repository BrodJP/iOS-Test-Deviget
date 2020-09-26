//
//  TopRedditProviderServiceMock.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import Foundation
@testable import iOSTestDeviget

class TopRedditProviderServiceMock: TopRedditProviderService {
    
    var fetchTopRedditCalled: Bool = false
    
    func fetchTopReddit(using page: TopRedditPage?,
                        completion: @escaping (Result<TopRedditResult, Error>) -> Void) {
        fetchTopRedditCalled = true
    }
}
