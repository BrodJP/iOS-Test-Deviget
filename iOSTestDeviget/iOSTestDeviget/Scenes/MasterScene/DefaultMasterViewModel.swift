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
    var selectedPost: RedditPostDTO?
    
    mutating func clear() {
        currentPage = nil
        posts = []
        selectedPost = nil
    }
}

class DefaultMasterViewModel: MasterViewModel {

    enum Constants {
        static let maxNumberOfPosts = 50
        static let coderRestorationID = "DatasourceDetailObject"
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
    
    var selectedPost: RedditPostDTO? {
        dataSource.selectedPost
    }
    
    private var dataSource: MasteViewModelDataSource
    
    init(service: TopRedditProviderService = DefaultTopRedditProviderService(),
         dataSource: MasteViewModelDataSource = MasteViewModelDataSource()) {
        self.service = service
        self.dataSource = dataSource
    }
    
    func initialize() {
        dataSource.clear()
        requestMorePosts()
    }
    
    func requestMorePosts() {
        if redditPosts.count < Constants.maxNumberOfPosts {
            requestMorePostsUsingPage(dataSource.currentPage)
        }
    }
    
    func selectPost(_ post: RedditPostDTO) {
        var mutablePost = post
        guard dataSource.selectedPost != mutablePost else {
            bindingDelegate?.showDetail()
            return
        }
        
        let indexOfNewSelection = dataSource.posts.firstIndex(of: mutablePost)
        mutablePost.isRead = true
        mutablePost.isSelected = true
        
        if let index = indexOfNewSelection {
            dataSource.posts[index] = mutablePost
        }
        
        if var selectedPost = dataSource.selectedPost {
            let indexOfOldSelection = dataSource.posts.firstIndex(of: selectedPost)
            selectedPost.isSelected = false
            if let index = indexOfOldSelection {
                dataSource.posts[index] = selectedPost
            }
        }
        
        dataSource.selectedPost = mutablePost
        reloadData()
        bindingDelegate?.showDetail()
    }
    
    func dismissPost(_ post: RedditPostDTO) {
        guard let index = dataSource.posts.firstIndex(of: post) else {
            return
        }
        dataSource.posts.remove(at: index)
        if dataSource.selectedPost == post {
            dataSource.selectedPost = nil
        }
        bindingDelegate?.reloadAllData()
    }
    
    func dismissAllPosts() {
        dataSource.clear()
        reloadData()
    }
    
    private func reloadData() {
        bindingDelegate?.reloadAllData()
    }
    
    func saveStateUsing(coder: NSCoder) {
        do {
            let data = try JSONEncoder().encode(dataSource)
            coder.encode(data, forKey: Constants.coderRestorationID)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func restoreStateUsing(coder: NSCoder) {
        guard let decodedData = coder.decodeObject(forKey: Constants.coderRestorationID) as? Data,
              let decodedDataSource = try? JSONDecoder().decode(MasteViewModelDataSource.self, from: decodedData) else {
            return
        }
        
        service.cancelCurrentRequest()
        dataSource = decodedDataSource
        reloadData()
        bindingDelegate?.showDetail()
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
