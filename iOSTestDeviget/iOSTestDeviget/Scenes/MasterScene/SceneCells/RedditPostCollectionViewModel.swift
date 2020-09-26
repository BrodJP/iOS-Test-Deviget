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
    private let redditPost: RedditPostDTO
    
    weak var delegate: RedditPostCollectionViewModelDelegate?
    
    init(redditPost: RedditPostDTO) {
        self.redditPost = redditPost
    }
    
    func onDismissButtonPressed() {
        delegate?.didTapDismissPost(redditPost)
    }
}
