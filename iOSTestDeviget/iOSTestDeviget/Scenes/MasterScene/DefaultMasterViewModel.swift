//
//  DefaultMasterViewModel.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

struct MasteViewModelDataSource: Codable {
    var currentPage: TopRedditPage?
    var posts: [RedditPostDTO] = []
    
    mutating func clear() {
        currentPage = nil
        posts = []
    }
}

class DefaultMasterViewModel: MasterViewModel {
    
    enum Constants {
        static let maxNumberOfPosts = 50
    }
    
    let service: TopRedditProviderService
    weak var bindingDelegate: MasterViewModelBinding?
    
    var screenTitle: String {
        "Reddit Posts"
    }
    
    var dismissButtonTitle: String {
        "Dismiss All"
    }
    
    var redditPosts: [RedditPostDTO] {
        return dataSource.posts
    }
    
    private var dataSource: MasteViewModelDataSource
    private(set) var selectedPost: RedditPostDTO?
    
    init(service: TopRedditProviderService = DefaultTopRedditProviderService(),
         dataSource: MasteViewModelDataSource = MasteViewModelDataSource()) {
        self.service = service
        self.dataSource = dataSource
    }
    
    func initialize() {
        dataSource.clear()
        selectedPost = nil
        requestMorePosts()
    }
    
    func requestMorePosts() {
        if redditPosts.count < Constants.maxNumberOfPosts {
            requestMorePostsUsingPage(dataSource.currentPage)
        }
    }
    
    func selectPost(_ post: RedditPostDTO) {
        var postsToReload = [post]
        
        if let selectedPost = selectedPost {
            selectedPost.isSelected = false
            postsToReload.append(selectedPost)
        }
        
        post.isRead = true
        post.isSelected = true
        selectedPost = post
        bindingDelegate?.reloadRedditPosts(postsToReload)
    }
    
    func dismissPost(_ post: RedditPostDTO) {
        guard let index = dataSource.posts.firstIndex(of: post) else {
            return
        }
        dataSource.posts.remove(at: index)
        if selectedPost == post {
            selectedPost = nil
        }
        bindingDelegate?.reloadAllData()
    }
    
    func dismissAllPosts() {
        dataSource.clear()
        selectedPost = nil
        reloadData()
    }
    
    private func reloadData() {
        bindingDelegate?.reloadAllData()
    }
    
    private func requestMorePostsUsingPage(_ page: TopRedditPage?) {
        service.fetchTopReddit(using: page,
                               completion: { [weak self] result in
                                    self?.handleFetchResult(result)
                               })
    }
    
    private func handleFetchResult(_ result: Result<TopRedditResult, Error>) {
        switch result {
        case .success(let topRedditResult):
            let newPage = TopRedditPage(after: topRedditResult.afterPage)
            var currentPosts = dataSource.posts
            currentPosts.append(contentsOf: topRedditResult.posts.map({ RedditPostDTO(redditPost: $0) }))
            dataSource.currentPage = newPage
            dataSource.posts = currentPosts
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        case .failure(let error):
            debugPrint("Handle error: \(error.localizedDescription)")
        }
    }
}
