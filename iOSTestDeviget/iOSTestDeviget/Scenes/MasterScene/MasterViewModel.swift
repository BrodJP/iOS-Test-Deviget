//
//  MasterViewModel.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

protocol MasterViewModelBinding: class {
    func reloadAllData()
    func reloadRedditPosts(_ posts: [RedditPostDTO])
}

protocol MasterViewModel {
    var redditPosts: [RedditPostDTO] { get }
    var selectedPost: RedditPostDTO? { get }
    var bindingDelegate: MasterViewModelBinding? { get set }
    var screenTitle: String { get }
    var dismissButtonTitle: String { get }
    
    func initialize()
    func requestMorePosts()
    func selectPost(_ post: RedditPostDTO)
    func dismissPost(_ post: RedditPostDTO)
    func dismissAllPosts()
}
