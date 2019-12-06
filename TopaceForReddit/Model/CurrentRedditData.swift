//
//  CurrentRedditData.swift
//  TopaceForReddit
//
//  Created by hesham on 12/16/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import Foundation

struct CurrentRedditData {
    private var subredditTitle = "popular"
    private var ID : String?
    private var sortAttr : RedditURL.topInterval?
    
    var redditURL : RedditURL {
        var redditURL = RedditURL()
        redditURL.addSubreddits(subreddits: getSubredditTitle())
        if let id = ID {
            redditURL.addPostID(afterID: id)
        }
        if let sortAttr = sortAttr {
            redditURL.addSortTopAndItsTimeInterval(interval: sortAttr)
        }
        return redditURL
    }
    
    
    mutating func setTitle(subredditNames: [String]) {
        var subs = ""
        for sub in subredditNames {
            subs += sub + "+"
        }
        subs.removeLast()
        self.subredditTitle = subs
    }
    
    mutating func setID(lastID: String?) {
        ID = lastID
    }
    
    func getSubredditTitle() -> String {
        return subredditTitle
    }
    
    func getID() -> String? {
        return ID
    }
    
    mutating func setSortAttr(sortInterval : RedditURL.topInterval) {
        sortAttr = sortInterval
    }
    
    mutating func clear() {
        subredditTitle = ""
        ID = nil
        sortAttr = nil
    }
}
