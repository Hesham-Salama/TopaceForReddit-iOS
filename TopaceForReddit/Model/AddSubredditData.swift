//
//  AddSubredditData.swift
//  TopaceForReddit
//
//  Created by hesham on 12/25/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import Foundation

struct AddSubredditData {
    var saveOptions = ["Don't save posts",
                      "Save top posts from the last week till today",
                      "Save top posts from the last month till today",
                      "Save top posts from the last year till today",
                      "Save top posts from all time"]

    var numPostsToSave = ["100 posts",
                          "200 posts",
                          "300 posts",
                          "500 posts"]
    
    let DUPLICATE_ACTIVE_MSG = "Error: That subreddit is already added."
    let ALPHANUMERIC_MSG = "Error: Subreddit should consist of English alphabet and numbers only"
    let EMPTY_WHITESPACE_MSG = "Error: Subreddit can't consist of white spaces"
    let WEAK_OR_NO_INTERNET_MESSAGE = "Error: No or weak internet connection."
    let SUBREDDIT_DOESNT_EXIST_MSG = "Error: That subreddit doesn't exist or has no posts."
    let SUBREDDIT_BANNED_MSG = "Error: That subreddit is banned."
}
