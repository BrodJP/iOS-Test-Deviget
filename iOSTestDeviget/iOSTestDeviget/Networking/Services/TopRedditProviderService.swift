//
//  TopRedditProviderService.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

protocol TopRedditProviderService {
    func fetchTopReddit(using page: TopRedditPage?,
                        completion: @escaping (Result<TopRedditResult, Error>) -> Void)
    func cancelCurrentRequest()
}

class DefaultTopRedditProviderService: TopRedditProviderService {
    let requester: Requester
    private(set) var currentTask: CancellableRequest?
    
    init(requester: Requester = DefaultRequester()) {
        self.requester = requester
    }
    
    func fetchTopReddit(using page: TopRedditPage?,
                        completion: @escaping (Result<TopRedditResult, Error>) -> Void) {
        cancelCurrentRequest()
        currentTask = requester.request(RedditEndpoint.top(after: page?.after), completion: completion)
    }
    
    func cancelCurrentRequest() {
        currentTask?.cancel()
    }
}
