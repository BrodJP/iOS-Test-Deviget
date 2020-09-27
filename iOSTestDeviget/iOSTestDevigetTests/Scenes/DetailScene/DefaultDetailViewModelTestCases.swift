//
//  DefaultDetailViewModelTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/27/20.
//

import XCTest
@testable import iOSTestDeviget

class DefaultDetailViewModelTestCases: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_expectedValuesReadFromRedditPostModel() throws {
        let redditPost = RedditPost(identifier: "MockID",
                                    title: "ExpectedTitle",
                                    author: "ExpectedAuthor",
                                    createdTimeInUnix: 999,
                                    thumbnail: URL(string: "www.reddit.com"),
                                    contentURL: URL(string: "www.google.com"),
                                    numberOfComments: 777,
                                    isVideo: true)
        
        let viewModel = DefaultDetailViewModel(redditPost: RedditPostDTO(redditPost: redditPost))
        
        XCTAssertEqual(viewModel.redditPostAuthor, redditPost.author)
        XCTAssertEqual(viewModel.redditPostText, redditPost.title)
        XCTAssertEqual(viewModel.redditPostThumbnailURL, redditPost.thumbnail)
        XCTAssertEqual(viewModel.contentURL, redditPost.contentURL)
        XCTAssertEqual(viewModel.mediaType, .video)
        XCTAssertTrue(viewModel.validContent)
    }
    
    func test_mediaTypeIsImage_forValidImageURL() throws {
        let redditPost = RedditPost(identifier: "MockID",
                                    title: "ExpectedTitle",
                                    author: "ExpectedAuthor",
                                    createdTimeInUnix: 999,
                                    thumbnail: URL(string: "www.reddit.com"),
                                    contentURL: URL(string: "www.google.com/image.jpg"),
                                    numberOfComments: 777,
                                    isVideo: false)
        
        let viewModel = DefaultDetailViewModel(redditPost: RedditPostDTO(redditPost: redditPost))
        
        XCTAssertEqual(viewModel.mediaType, .image)
    }
    
    func test_mediaTypeIsVideo_forIsVideoProperty() throws {
        let redditPost = RedditPost(identifier: "MockID",
                                    title: "ExpectedTitle",
                                    author: "ExpectedAuthor",
                                    createdTimeInUnix: 999,
                                    thumbnail: URL(string: "www.reddit.com"),
                                    contentURL: URL(string: "www.google.com/image.jpg"),
                                    numberOfComments: 777,
                                    isVideo: true)
        
        let viewModel = DefaultDetailViewModel(redditPost: RedditPostDTO(redditPost: redditPost))
        
        XCTAssertEqual(viewModel.mediaType, .video)
    }
    
    func test_mediaTypeIsUnknown_givenIsVideoPropertyFalse_andContentURLIsNil() throws {
        let redditPost = RedditPost(identifier: "MockID",
                                    title: "ExpectedTitle",
                                    author: "ExpectedAuthor",
                                    createdTimeInUnix: 999,
                                    thumbnail: URL(string: "www.reddit.com"),
                                    contentURL: nil,
                                    numberOfComments: 777,
                                    isVideo: false)
        
        let viewModel = DefaultDetailViewModel(redditPost: RedditPostDTO(redditPost: redditPost))
        
        XCTAssertEqual(viewModel.mediaType, .unknown)
    }
    
    func test_invalirContent_forNilRedditPost() throws {
        let viewModel = DefaultDetailViewModel(redditPost: nil)
        XCTAssertFalse(viewModel.validContent)
    }
}
