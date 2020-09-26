//
//  TopRedditResult.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

struct TopRedditResult: Decodable {
    var posts: [RedditPost] {
        return data.posts
    }
    
    var afterPage: String {
        return data.after
    }
    
    let data: TopRedditResultData
}

struct TopRedditResultData: Decodable {
    var posts: [RedditPost] {
        return children.map({ $0.data })
    }
    
    let after: String
    let children: [TopRedditResultDataChildren]
}

struct TopRedditResultDataChildren: Decodable {
    let data: RedditPost
}
