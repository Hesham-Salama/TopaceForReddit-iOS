//
//  RedditURL.swift
//  TopaceForReddit
//
//  Created by hesham on 11/18/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import Foundation

struct RedditURL {

    enum limit : Int {
        case limit_100 = 100
        case limit_25 = 25
        case limit_10 = 10
        case limit_1 = 1
    }
    enum topInterval : String {
        case new = "new"
        case day = "day"
        case week = "week"
        case month = "month"
        case year = "year"
        case all = "all"
    }
    private var components = URLComponents()
    var url: URL?  {
        return components.url
    }

    init() {
        components.scheme = "https"
        components.host = "oauth.reddit.com"
        components.path = "/r/"
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "raw_json", value: "1"))
    }

    mutating func addSubreddits(subreddits : String) {
        components.path += "\(subreddits)/"
    }

    mutating func addSortTopAndItsTimeInterval(interval : topInterval) {
        if interval == .new {
            components.path += "\(interval.rawValue)/"
        } else {
            components.path += "top/"
            components.queryItems?.append(URLQueryItem(name: "sort", value: "top"))
            components.queryItems?.append(URLQueryItem(name: "t", value: interval.rawValue))
        }
    }

    mutating func addLimit(lim : limit) {
        components.queryItems?.append(URLQueryItem(name: "limit", value: String(describing: lim.rawValue)))
    }

    mutating func addPostID(afterID id: String) {
        components.queryItems?.append(URLQueryItem(name: "after", value: id))
    }

    mutating func makeCommentAndAddArticleID(articleID id: String) {
        components.path += "comments/articles/"
        components.queryItems?.append(URLQueryItem(name: "showmore", value: "true"))
        components.queryItems?.append(URLQueryItem(name: "article", value: id))
    }
}
