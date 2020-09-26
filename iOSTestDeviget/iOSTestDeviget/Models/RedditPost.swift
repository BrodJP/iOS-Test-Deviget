//
//  RedditPost.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

struct RedditPost: Codable {
    let identifier: String
    let title: String
    let author: String
    let createdTimeInUnix: TimeInterval
    let thumbnail: URL?
    let contentURL: URL?
    let numberOfComments: Int
    let isVideo: Bool
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case author
        case createdTimeInUnix = "created_utc"
        case thumbnail
        case contentURL = "url"
        case numberOfComments = "num_comments"
        case isVideo = "is_video"
    }
}
