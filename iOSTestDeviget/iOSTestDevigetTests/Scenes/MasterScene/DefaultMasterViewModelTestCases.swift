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
    var showDetailCalled: Bool = false
    
    func reloadAllData() {
        reloadAllDataCalled = true
    }
    
    func showDetail() {
        showDetailCalled = true
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
    
    func test_correct_initialization_forFailureFetch() {
        var dataSource = MasteViewModelDataSource()
        let service = TopRedditProviderServiceMock()
        service.forceFetchFailure = true
        let mockPostDTO = RedditPostDTO(redditPost: mockPost)
        dataSource.posts = [mockPostDTO]
        let viewModel = DefaultMasterViewModel(service: service, dataSource: dataSource)
        viewModel.selectPost(mockPostDTO)
        
        viewModel.initialize()
        XCTAssertTrue(viewModel.redditPosts.isEmpty, "Expected posts to be cleared")
        XCTAssertNil(viewModel.selectedPost, "Expected selected posts to be cleared")
        XCTAssertTrue(service.fetchTopRedditCalled, "Expected service to fetch data")
    }
    
    func test_requestMorePosts_executed_ifPostLessThanMaxNumberOfPosts() {
        let dataSource = MasteViewModelDataSource()
        let service = TopRedditProviderServiceMock()
    
        let viewModel = DefaultMasterViewModel(service: service, dataSource: dataSource)
        viewModel.requestMorePosts()
        
        XCTAssertTrue(service.fetchTopRedditCalled, "Fetch must not happen")
    }
    
    func test_requestMorePosts_success_populatesDataSource() {
        let dataSource = MasteViewModelDataSource()
        let service = TopRedditProviderServiceMock()
    
        let viewModel = DefaultMasterViewModel(service: service, dataSource: dataSource)
        XCTAssertTrue(viewModel.redditPosts.isEmpty)
        
        viewModel.requestMorePosts()
        
        XCTAssertFalse(viewModel.redditPosts.isEmpty)
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
        var mockPostDTO = RedditPostDTO(redditPost: mockPost)
        mockPostDTO.isSelected = false
        
        viewModel.selectPost(mockPostDTO)
        
        XCTAssertEqual(viewModel.selectedPost?.redditPost.identifier, mockPost.identifier)
        XCTAssertTrue(viewModel.selectedPost?.isSelected == true)
        XCTAssertTrue(bindingDelegate.reloadAllDataCalled, "Expected to reload UI posts")
        XCTAssertTrue(bindingDelegate.showDetailCalled, "Expected to trigger shot detail of selected Post")
    }
    
    func test_selectPost_deselectPreviousSelectedPost() {
        var dataSource = MasteViewModelDataSource()
        
        var oldPostDTO = RedditPostDTO(redditPost: mockPost)
        oldPostDTO.isSelected = false
        var newPostDTO = RedditPostDTO(redditPost: mockPost)
        newPostDTO.isSelected = false
        
        // Populate mock fetched dataSource
        dataSource.posts = [oldPostDTO, newPostDTO]
        
        let viewModel = DefaultMasterViewModel(dataSource: dataSource)
        
        // Selects oldPostDTO first
        viewModel.selectPost(oldPostDTO)
        
        // Check oldPostDTO entity was selected
        oldPostDTO = viewModel.redditPosts.first(where: { $0.redditPost.identifier == oldPostDTO.redditPost.identifier })!
        XCTAssertTrue(oldPostDTO.isSelected)
        XCTAssertEqual(viewModel.selectedPost, oldPostDTO)
        
        // Selects newPostDTO
        viewModel.selectPost(newPostDTO)
        
        // Check oldPostDTO entity was deselected
        oldPostDTO = viewModel.redditPosts.first(where: { $0.redditPost.identifier == oldPostDTO.redditPost.identifier })!
        XCTAssertFalse(oldPostDTO.isSelected)
        XCTAssertNotEqual(viewModel.selectedPost, oldPostDTO)
    }
    
    func test_dismissPost_removesPostFromDatasource() {
        var dataSource = MasteViewModelDataSource()
        let postToBeDismiss = RedditPostDTO(redditPost: mockPost)
        dataSource.posts = [postToBeDismiss]
        
        let viewModel = DefaultMasterViewModel(dataSource: dataSource)
        
        XCTAssertFalse(viewModel.redditPosts.isEmpty)
        
        viewModel.dismissPost(postToBeDismiss)
        
        XCTAssertTrue(viewModel.redditPosts.isEmpty)
    }
    
    func test_dismissPost_clearsSelectedPost_ifItWasSelectedBefore() {
        var dataSource = MasteViewModelDataSource()
        let postToBeSelected = RedditPostDTO(redditPost: mockPost)
        dataSource.posts = [postToBeSelected]
        
        let viewModel = DefaultMasterViewModel(dataSource: dataSource)
        
        XCTAssertNil(viewModel.selectedPost)
        
        viewModel.selectPost(postToBeSelected)
        
        XCTAssertNotNil(viewModel.selectedPost)
        
        // Remember this is a struct, we are making isSelected/isRead = true to ensure is equal to the one stored on dataSource
        var postToBeDismissed = postToBeSelected
        postToBeDismissed.isSelected = true
        postToBeDismissed.isRead = true
        viewModel.dismissPost(postToBeDismissed)
        
        XCTAssertNil(viewModel.selectedPost)
    }
    
    func test_dismissAllPost_executesReloadAllData() {
        let bindingDelegate = MasterViewModelBindingMock()
        let viewModel = DefaultMasterViewModel()
        viewModel.bindingDelegate = bindingDelegate
        
        viewModel.dismissAllPosts()
        
        XCTAssertTrue(bindingDelegate.reloadAllDataCalled)
    }
    
    func test_dismissAllPost_clearPostsData() {
        var dataSource = MasteViewModelDataSource()
        let mockPostDTO = RedditPostDTO(redditPost: mockPost)
        dataSource.posts = [mockPostDTO]
        
        let viewModel = DefaultMasterViewModel(dataSource: dataSource)
        
        viewModel.dismissAllPosts()
        
        XCTAssertTrue(viewModel.redditPosts.isEmpty)
    }
}
