//
//  JSONDataLoader.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/27/20.
//

import Foundation

class JSONDataLoader {
    enum LoaderError: Error {
        case invalidJson
    }
    
    static func topRedditData() throws -> Data {
        
        if let url = Bundle(for: JSONDataLoader.self).url(forResource: "topReddit", withExtension: "json") {
            return try Data(contentsOf: url)
        }
        throw LoaderError.invalidJson
    }
}
