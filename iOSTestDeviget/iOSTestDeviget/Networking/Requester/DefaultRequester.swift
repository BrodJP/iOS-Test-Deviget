//
//  DefaultRequester.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

class DefaultRequester: Requester {
    
    enum Constants {
        static let timeoutInterval: TimeInterval = 10.0
    }
    
    let dataTaskFactory: URLSessionDataTaskFactory
    
    init(dataTaskFactory: URLSessionDataTaskFactory = URLSession.shared) {
        self.dataTaskFactory = dataTaskFactory
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint,
                               completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let request = try self.buildRequest(from: endpoint)
            let task = dataTaskFactory.dataTask(with: request,
                                                completionHandler: { [weak self] data, response, error in
                                                    self?.handleResponse(data: data,
                                                                         response: response,
                                                                         error: error,
                                                                         completion: completion)
                                                })
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
 
    fileprivate func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: Constants.timeoutInterval)
        
        request.httpMethod = endpoint.httpMethod.rawValue
        do {
            switch endpoint.task {
            case .requestWithParameters(let urlParameters, let parametersEncoder):
                try parametersEncoder.encode(urlRequest: &request,
                                             parameters: urlParameters)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func handleResponse<T: Decodable>(data: Data?,
                                                  response: URLResponse?,
                                                  error: Error?,
                                                  completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.handleStatusCodeFrom(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    completion(.failure(RequesterError.noData))
                    return
                }
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    //print(jsonString)
                }
                do {
                    let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                    completion(.success(apiResponse))
                }catch {
                    completion(.failure(error))
                }
            case .failure(let networkFailureError):
                completion(.failure(networkFailureError))
            }
        }
    }
    
    fileprivate func handleStatusCodeFrom(_ response: HTTPURLResponse) -> Result<Void, RequesterError> {
        switch response.statusCode {
        case 200...299: return .success(())
        default: return .failure(.responseError)
        }
    }
}
