//
//  DetailViewModel.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import Foundation

protocol DetailViewModel {
    var isVideoString: String { get }
    var redditPostAuthor: String? { get }
    var redditPostText: String? { get }
    var redditPostThumbnailURL: URL? { get }
    var contentURL: URL? { get }
    var mediaType: MediaType { get }
    var validContent: Bool { get }
}

class DefaultDetailViewModel: DetailViewModel {
    enum Constants {
        static let coderRestorationID = "PostDetailObject"
    }
    
    var redditPost: RedditPostDTO?
    
    init(redditPost: RedditPostDTO? = nil) {
        self.redditPost = redditPost
    }
    
    var isVideoString: String {
        "(Video)"
    }
    
    var redditPostAuthor: String? {
        redditPost?.redditPost.author
    }
    
    var redditPostText: String? {
        redditPost?.redditPost.title
    }
    
    var redditPostThumbnailURL: URL? {
        redditPost?.redditPost.thumbnail
    }
    
    var contentURL: URL? {
        redditPost?.redditPost.contentURL
    }
    
    var mediaType: MediaType {
        redditPost?.mediaType ?? .unknown
    }
    
    var validContent: Bool {
        redditPost != nil
    }
}

