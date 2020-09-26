//
//  RedditPostDTO.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import UIKit

class RedditPostDTO: Codable, Hashable {
    let redditPost: RedditPost
    var isRead: Bool
    var isSelected: Bool
    
    init(redditPost: RedditPost) {
        self.redditPost = redditPost
        self.isRead = false
        self.isSelected = false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isRead)
        hasher.combine(isSelected)
        hasher.combine(redditPost.identifier)
    }
    
    static func == (lhs: RedditPostDTO, rhs: RedditPostDTO) -> Bool {
        (lhs.isRead == rhs.isRead)
            && (lhs.isSelected == rhs.isSelected)
            && (lhs.redditPost.identifier == rhs.redditPost.identifier)
    }
}
