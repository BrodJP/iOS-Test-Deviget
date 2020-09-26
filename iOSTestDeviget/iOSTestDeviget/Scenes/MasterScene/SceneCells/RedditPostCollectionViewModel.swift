//
//  RedditPostCollectionViewModel.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

protocol RedditPostCollectionViewModelDelegate: class {
    func didTapDismissPost(_ post: RedditPostDTO)
}

struct RedditPostCollectionViewModel {
    let title: String
    let author: String
    let entryDateString: String
    let thumbnailURL: URL?
    let numberOfCommentsString: String
    let isRead: Bool
    let isSelected: Bool
    private let redditPost: RedditPostDTO
    
    weak var delegate: RedditPostCollectionViewModelDelegate?
    
    init(redditPost: RedditPostDTO,
         currentDate: DateProvider = Date()) {
        self.title = redditPost.redditPost.title
        self.author = redditPost.redditPost.author
        
        let secondsPerHour: TimeInterval = 3600
        let currentSeconds = currentDate.timeIntervalSince1970
        let elapsedTimeInSeconds = currentSeconds - redditPost.redditPost.createdTimeInUnix
        let elapsedTimeInHours = elapsedTimeInSeconds/secondsPerHour
        
        self.entryDateString = String(format: "%.2f hours ago", elapsedTimeInHours)
        self.thumbnailURL = redditPost.redditPost.thumbnail
        self.numberOfCommentsString = "\(redditPost.redditPost.numberOfComments) comments"
        self.isRead = redditPost.isRead
        self.isSelected = redditPost.isSelected
        self.redditPost = redditPost
    }
    
    func onDismissButtonPressed() {
        delegate?.didTapDismissPost(redditPost)
    }
}
