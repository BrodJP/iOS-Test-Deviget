//
//  TopRedditProviderServiceMock.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import Foundation
@testable import iOSTestDeviget

class TopRedditProviderServiceMock: TopRedditProviderService {
  
    enum ServiceError: Error {
        case forcedError
    }
    
    var fetchTopRedditCalled: Bool = false
    var cancelRequestCalled: Bool = false
    var forceFetchFailure: Bool = false
    
    func fetchTopReddit(using page: TopRedditPage?,
                        completion: @escaping (Result<TopRedditResult, Error>) -> Void) {
        fetchTopRedditCalled = true
        if forceFetchFailure {
            completion(.failure(ServiceError.forcedError))
            return
        }
        
        do {
            let data = try JSONDataLoader.topRedditData()
            let result = try JSONDecoder().decode(TopRedditResult.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
    
    func cancelCurrentRequest() {
        cancelRequestCalled = false
    }
}
