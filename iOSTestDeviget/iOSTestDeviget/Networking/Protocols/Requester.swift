//
//  Requester.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

protocol Requester: class {
    func request<T: Decodable>(_ endpoint: Endpoint,
                               completion: @escaping (Result<T, Error>) -> Void)
}
