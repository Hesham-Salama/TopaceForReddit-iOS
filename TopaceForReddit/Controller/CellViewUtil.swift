//
//  cellViewUtil.swift
//  TopaceForReddit
//
//  Created by hesham on 11/25/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import Kingfisher

struct CellViewUtil {
    
    static var currentTimeInMilliSeconds : Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }

    static func prepareCell(postData : PostData?, index : Int, image: UIImage?, myCell : RedditPostCollectionViewCell) -> RedditPostCollectionViewCell {
        if let image = image {
            myCell.postImage.image = image
        }
        else if let thumbLink = postData?.data.children[index].data.mThumbnailLink {
            if thumbLink == "self" {
                myCell.postImage.image = UIImage(named: "text_thumb")
            }
            else if thumbLink.trimmingCharacters(in: .whitespacesAndNewlines) == "" || thumbLink == "default" ||
                thumbLink == "nsfw" {
                myCell.postImage.image = UIImage(named: "no_thumb")
            } else {
                let url = URL(string: thumbLink)
                myCell.postImage.kf.setImage(with: url)
            }
        }
        let score = postData?.data.children[index].data.mScore ?? 0
        myCell.postScore.text = "\(score)"
        myCell.postTitle.text = postData?.data.children[index].data.mTitle ?? "title_error"
        let numOfComments = postData?.data.children[index].data.mNoOfComments ?? 0
        myCell.postNumberOfComments.text = "- \(numOfComments) comments"
        myCell.postSubmitter.text = "/u/\(postData?.data.children[index].data.mAuthor  ?? "submitter_error")"
        if let timeStr = extractTimeOfNow(delta: postData?.data.children[index].data.mCreatedUTC) {
            myCell.postTime.text = "Submitted " + timeStr
        } else {
            myCell.postTime.text = "Submitted " + "error_time_nil"
        }
        myCell.subredditTitle.text = postData?.data.children[index].data.mSubreddit ?? "subreddit_title_error"
        return myCell
    }

    static func extractTimeOfNow(delta: Int?) -> String? {
        let mDate = currentTimeInMilliSeconds
        if let delta = delta {
            let newDelta = delta * 1000
            if mDate > newDelta {
                let difference = mDate - newDelta
                let seconds = difference / 1000
                let minutes = seconds / 60
                let hours = minutes / 60
                let days = hours / 24
                let months = days / 31
                let years = days / 365

                switch seconds {
                case ..<0: return "incorrect_phone_date"
                case ..<60: return "just now"
                case ..<(60 * 2): return "a minute ago"
                case ..<(60 * 60): return "\(minutes)" + " minutes ago"
                case ..<(2 * 60 * 60): return "an hour ago"
                case ..<(24 * 60 * 60): return "\(hours)" + " hours ago"
                case ..<(48 * 60 * 60): return "1 day ago"
                case ..<(30 * 24 * 60 * 60): return "\(days)" + " days ago"
                case ..<(60 * 24 * 60 * 60): return "1 month ago"
                case ..<(365 * 24 * 60 * 60): return "\(months)" + " months ago"
                default:
                    if (years <= 1) {
                        return "1 year ago"
                    }
                    else {
                        return "\(years)" + " years ago"
                    }
                }
            }
        }
        return nil
    }
    
}
