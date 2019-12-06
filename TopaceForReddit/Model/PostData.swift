//
//  PostData.swift
//  TopaceForReddit
//
//  Created by hesham on 11/18/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import Foundation

class PostData: Codable {

    private static var mPosts : [PostData]? = nil

    struct Data: Codable {
        struct Children: Codable {
            struct Data : Codable {

                struct Preview : Codable {
                    struct Images : Codable {
                        struct Source : Codable {
                            let url : String?
                        }
                        let source : Source
                    }
                    let images : [Images]
                }

                let mTitle : String?
                let mSubreddit: String?
                let mScore: Int?
                let mThumbnailLink: String?
                let mCreatedUTC: Int?
                let mAuthor: String?
                let mNoOfComments: Int?
                let mURL: String?
                let mPermalink: String?
                let mSelfText_HTML: String?
                let mDomain: String?
                let mID: String?

                private enum CodingKeys: String, CodingKey {
                    case mSubreddit = "subreddit"
                    case mSelfText_HTML = "selftext_html"
                    case mTitle = "title"
                    case mScore = "score"
                    case mThumbnailLink = "thumbnail"
                    case mCreatedUTC = "created_utc"
                    case mAuthor = "author"
                    case mNoOfComments = "num_comments"
                    case mURL = "url"
                    case mPermalink = "permalink"
                    case mDomain = "domain"
                    case mID = "name"
                    case preview
                }
                let preview : Preview?
            }
            let data : Data
        }
        var children : [Children]
    }
    var data : Data

    static func getPosts() -> [PostData]? {
        return mPosts
    }

    static func setPosts(posts: [PostData]?) {
        mPosts = posts
    }
}
