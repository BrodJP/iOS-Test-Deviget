//
//  RedditEndpoint.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

enum RedditEndpoint: Endpoint {
    
    enum Constants {
        static let baseURLString = "https://www.reddit.com/"
        static let itemsPerPage = 10
    }
    
    case top(after: String?)
    
    var baseURL: URL {
        guard let url = URL(string: Constants.baseURLString) else {
            fatalError("Base URL required")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .top:
            return "top.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .top:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .top(let after):
            var parameters: Parameters = ["limit": Constants.itemsPerPage]
            parameters["after"] = after
            return .requestWithParameters(urlParameters: parameters,
                                          encoder: .urlEncoding)
        }
    }
}
