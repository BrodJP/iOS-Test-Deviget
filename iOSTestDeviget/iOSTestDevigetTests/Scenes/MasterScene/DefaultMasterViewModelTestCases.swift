//
//  DefaultMasterViewModelTestCases.swift
//  iOSTestDevigetTests
//
//  Created by Bryan Rodriguez on 9/26/20.
//

import XCTest
@testable import iOSTestDeviget

private class MasterViewModelBindingMock: MasterViewModelBinding {
    var reloadAllDataCalled: Bool = false
    var reloadRedditPostsCalled: Bool = false
    
    func reloadAllData() {
        reloadAllDataCalled = true
    }
    
    func reloadRedditPosts(_ posts: [RedditPostDTO]) {
        reloadRedditPostsCalled = true
    }
}

class DefaultMasterViewModelTestCases: XCTestCase {

    let mockPost = RedditPost(identifier: "MockID",
                              title: "",
                              author: "",
                              createdTimeInUnix: 0,
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

    func test_expectedScreenTitle() {
        let viewModel = DefaultMasterViewModel()
        XCTAssertEqual(viewModel.screenTitle, "Reddit Posts")
    }
    
    func test_expectedDismissButtonTitle() {
        let viewModel = DefaultMasterViewModel()
        XCTAssertEqual(viewModel.dismissButtonTitle, "Dismiss All")
    }
    
    func test_expectedRedditPostReadFromDataSource() {
        var dataSource = MasteViewModelDataSource()
        dataSource.posts = [RedditPostDTO(redditPost: mockPost)]
        let viewModel = DefaultMasterViewModel(dataSource: dataSource)
        XCTAssertEqual(viewModel.redditPosts, dataSource.posts)
    }
    
    func test_correct_initialization() {
        var dataSource = MasteViewModelDataSource()
        let service = TopRedditProviderServiceMock()
        let mockPostDTO = RedditPostDTO(redditPost: mockPost)
        dataSource.posts = [mockPostDTO]
        let viewModel = DefaultMasterViewModel(service: service, dataSource: dataSource)
        viewModel.selectPost(mockPostDTO)
        
        viewModel.initialize()
        XCTAssertTrue(viewModel.redditPosts.isEmpty, "Expected posts to be cleared")
        XCTAssertNil(viewModel.selectedPost, "Expected selected posts to be cleared")
        XCTAssertTrue(service.fetchTopRedditCalled, "Expected service to fetch data")
    }
    
    func test_requestMorePosts_notExecuted_ifMaxNumberOfPostsIsMet() {
        var dataSource = MasteViewModelDataSource()
        let service = TopRedditProviderServiceMock()
        let mockPostDTO = RedditPostDTO(redditPost: mockPost)
        
        while dataSource.posts.count < DefaultMasterViewModel.Constants.maxNumberOfPosts {
            dataSource.posts.append(mockPostDTO)
        }
        
        let viewModel = DefaultMasterViewModel(service: service, dataSource: dataSource)
        viewModel.requestMorePosts()
        
        XCTAssertFalse(service.fetchTopRedditCalled, "Fetch must not happen")
    }
    
    func test_selectPost_executesReloadPostsAction() {
        let bindingDelegate = MasterViewModelBindingMock()
        let viewModel = DefaultMasterViewModel()
        viewModel.bindingDelegate = bindingDelegate
        let mockPostDTO = RedditPostDTO(redditPost: mockPost)
        mockPostDTO.isSelected = false
        viewModel.selectPost(mockPostDTO)
        
        XCTAssertTrue(mockPostDTO.isSelected)
        XCTAssertTrue(bindingDelegate.reloadRedditPostsCalled, "Expected to reload selected and deselected posts")
    }
    
    func test_selectPost_deselectPreviousSelectedPost() {
        let viewModel = DefaultMasterViewModel()
        let oldPostDTO = RedditPostDTO(redditPost: mockPost)
        oldPostDTO.isSelected = false
        let newPostDTO = RedditPostDTO(redditPost: mockPost)
        newPostDTO.isSelected = false
        viewModel.selectPost(oldPostDTO)
        viewModel.selectPost(newPostDTO)
        
        XCTAssertFalse(oldPostDTO.isSelected, "Expected to deselect old previos post")
        XCTAssertTrue(newPostDTO.isSelected, "Expected to select new previos post")
    }
    
    func test_dismissPost_executesReloadAllData() {
        let bindingDelegate = MasterViewModelBindingMock()
        let viewModel = DefaultMasterViewModel()
        viewModel.bindingDelegate = bindingDelegate
        
        viewModel.dismissAllPosts()
        
        XCTAssertTrue(bindingDelegate.reloadAllDataCalled)
    }
    
    func test_dismissPost_clearPostsData() {
        var dataSource = MasteViewModelDataSource()
        let mockPostDTO = RedditPostDTO(redditPost: mockPost)
        dataSource.posts = [mockPostDTO]
        
        let viewModel = DefaultMasterViewModel(dataSource: dataSource)
        
        viewModel.dismissAllPosts()
        
        XCTAssertTrue(viewModel.redditPosts.isEmpty)
    }
}
