//
//  RedditPostCollectionViewModelTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import XCTest
@testable import iOSTestDeviget

struct DateProviderMock: DateProvider {
    enum Constants {
        static let threeHoursInSeconds: TimeInterval = 3600*3
    }
    var timeIntervalSince1970: TimeInterval = Constants.threeHoursInSeconds
}

class RedditPostCollectionViewModelTestCases: XCTestCase {

    enum Constants {
        static let oneHoursInSeconds: TimeInterval = 3600
        static let thumbnailURLString = "www.reddit.com"
        static let contentURLString = "www.google.com"
    }
    
    let redditPost = RedditPost(identifier: "MockID",
                                title: "MockTitle",
                                author: "MockAuthor",
                                createdTimeInUnix: Constants.oneHoursInSeconds,
                                thumbnail: URL(string: Constants.thumbnailURLString),
                                contentURL: URL(string: Constants.contentURLString),
                                numberOfComments: 777,
                                isVideo: false)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initialization() {
        var redditPostDTO = RedditPostDTO(redditPost: redditPost)
        redditPostDTO.isSelected = true
        redditPostDTO.isRead = true
        
        let viewModel = RedditPostCollectionViewModel(redditPost: redditPostDTO,
                                                      currentDate: DateProviderMock())
        
        XCTAssertEqual(viewModel.title, redditPost.title)
        XCTAssertEqual(viewModel.author, redditPost.author)
        XCTAssertEqual(viewModel.entryDateString, "2.00 hours ago")
        XCTAssertEqual(viewModel.thumbnailURL?.absoluteString, Constants.thumbnailURLString)
        XCTAssertEqual(viewModel.numberOfCommentsString, "777 comments")
        XCTAssertEqual(viewModel.isRead, redditPostDTO.isRead)
        XCTAssertEqual(viewModel.isSelected, redditPostDTO.isRead)
    }
}
