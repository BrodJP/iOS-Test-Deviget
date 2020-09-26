//
//  ImageDownloader.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

// A Basic image downloader and cache
class ImageDownloader {

    let dataTaskFactory: URLSessionDataTaskFactory
    
    private(set) var currentTask: CancellableRequest?
    
    init(dataTaskFactory: URLSessionDataTaskFactory = URLSession.shared) {
        self.dataTaskFactory = dataTaskFactory
    }

    func loadImageWithUrl(_ url: URL,
                          onComplete: @escaping (Result<UIImage, Error>) -> Void) {
        cancelCurrentTaskIfAny()
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            onComplete(.success(imageFromCache))
            return
        }
        
        currentTask = dataTaskFactory.cancellableDataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                onComplete(.failure(error))
                return
            }
            if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                onComplete(.success(imageToCache))
                imageCache.setObject(imageToCache, forKey: url as AnyObject)
            }
        })
        
        currentTask?.resume()
    }
    
    func cancelCurrentTaskIfAny() {
        currentTask?.cancel()
    }
}
