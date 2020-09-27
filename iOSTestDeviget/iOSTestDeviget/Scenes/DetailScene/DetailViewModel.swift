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

struct DefaultDetailViewModel: DetailViewModel {
    let redditPostAuthor: String?
    let redditPostText: String?
    let redditPostThumbnailURL: URL?
    let contentURL: URL?
    let mediaType: MediaType
    let validContent: Bool
    
    var isVideoString: String {
        "(Video)"
    }
    
    init(redditPost: RedditPostDTO? = nil) {
        redditPostAuthor = redditPost?.redditPost.author
        redditPostText = redditPost?.redditPost.title
        redditPostThumbnailURL = redditPost?.redditPost.thumbnail
        contentURL = redditPost?.redditPost.contentURL
        mediaType = redditPost?.mediaType ?? .unknown
        validContent = redditPost != nil
    }
}

