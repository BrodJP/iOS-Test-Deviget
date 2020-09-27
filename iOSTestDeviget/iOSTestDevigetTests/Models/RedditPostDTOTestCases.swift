//
//  RedditPostDTOTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import XCTest
@testable import iOSTestDeviget

class RedditPostDTOTestCases: XCTestCase {

    let redditPost = RedditPost(identifier: "FirstIdentifier",
                                title: "",
                                author: "",
                                createdTimeInUnix: Date().timeIntervalSince1970,
                                thumbnail: nil,
                                contentURL: nil,
                                numberOfComments: 0,
                                isVideo: false)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_equalModels_given_falseSelectedAndFalseRead() throws {
        var firstPost = RedditPostDTO(redditPost: redditPost)
        firstPost.isSelected = false
        firstPost.isRead = false
        var secondPost = RedditPostDTO(redditPost: redditPost)
        secondPost.isSelected = false
        secondPost.isRead = false
        
        XCTAssertEqual(firstPost, secondPost)
    }
    
    func test_equalModels_given_trueSelectedAndTrueRead() throws {
        var firstPost = RedditPostDTO(redditPost: redditPost)
        firstPost.isSelected = true
        firstPost.isRead = true
        var secondPost = RedditPostDTO(redditPost: redditPost)
        secondPost.isSelected = true
        secondPost.isRead = true
        
        XCTAssertEqual(firstPost, secondPost)
    }
    
    func test_equalModels_given_trueSelectedAndFalseRead() throws {
        var firstPost = RedditPostDTO(redditPost: redditPost)
        firstPost.isSelected = true
        firstPost.isRead = false
        var secondPost = RedditPostDTO(redditPost: redditPost)
        secondPost.isSelected = true
        secondPost.isRead = false
        
        XCTAssertEqual(firstPost, secondPost)
    }
    
    func test_notEqualModels_givenDifferentPostID() throws {
        let firstRedditPost = redditPost
        let secondRedditPost = RedditPost(identifier: "SecondIdentifier",
                                          title: "",
                                          author: "",
                                          createdTimeInUnix: Date().timeIntervalSince1970,
                                          thumbnail: nil,
                                          contentURL: nil,
                                          numberOfComments: 0,
                                          isVideo: false)
        
        var firstPost = RedditPostDTO(redditPost: firstRedditPost)
        firstPost.isSelected = false
        firstPost.isRead = false
        var secondPost = RedditPostDTO(redditPost: secondRedditPost)
        secondPost.isSelected = false
        secondPost.isRead = false
        
        XCTAssertNotEqual(firstPost, secondPost)
    }
}
