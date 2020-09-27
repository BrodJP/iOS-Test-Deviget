//
//  RedditPostDTO.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import UIKit

// Data Transfer Object
struct RedditPostDTO: Codable, Hashable {
    let redditPost: RedditPost
    var isRead: Bool
    var isSelected: Bool
    var mediaType: MediaType {
        if redditPost.isVideo == true {
            return .video
        } else if redditPost.contentURL?.absoluteString.hasSuffix(".jpg") ?? false {
            return .image
        }
        return .unknown
    }
    
    init(redditPost: RedditPost) {
        self.redditPost = redditPost
        self.isRead = false
        self.isSelected = false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(redditPost.identifier)
    }
    
    static func == (lhs: RedditPostDTO, rhs: RedditPostDTO) -> Bool {
        (lhs.isRead == rhs.isRead)
            && (lhs.isSelected == rhs.isSelected)
            && (lhs.redditPost.identifier == rhs.redditPost.identifier)
    }
}
