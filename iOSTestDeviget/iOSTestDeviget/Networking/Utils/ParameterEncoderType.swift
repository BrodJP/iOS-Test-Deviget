//
//  ParameterEncoder.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

public enum ParameterEncoderType {
    
    case urlEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       parameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let parameters = parameters else {
                    return
                }
                try URLParameterEncoder().encode(urlRequest: &urlRequest,
                                                 with: parameters)
            }
        } catch {
            throw error
        }
    }
}
