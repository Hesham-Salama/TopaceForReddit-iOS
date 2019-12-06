//
//  RedditPostCollectionViewCell.swift
//  TopaceForReddit
//
//  Created by hesham on 11/15/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import Foundation


class RedditPostCollectionViewCell: UICollectionViewCell {

    let SMALL_FONT_SIZE = 12
    let MEDIUM_FONT_SIZE = 15
    private var widthConstraint: NSLayoutConstraint?

    let postImage = UIImageView()
    let subredditTitle = UILabel()
    let postScore = UILabel()
    let postTitle = UILabel()
    let postSubmitter = UILabel()
    let postNumberOfComments = UILabel()
    let postTime = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        postTitle.numberOfLines = 0
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)

        customizeCellForm()
        assignFontSizes()
        assignFontColors()
        makingTranslationFalse()

        contentView.addSubview(postImage)
        contentView.addSubview(subredditTitle)
        contentView.addSubview(postScore)
        contentView.addSubview(postTitle)
        contentView.addSubview(postSubmitter)
        contentView.addSubview(postNumberOfComments)
        contentView.addSubview(postTime)

        addConstraintsToViews()
    }

    func customizeCellForm(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.7
    }

    func assignFontSizes() {
        subredditTitle.font = subredditTitle.font.withSize(CGFloat(SMALL_FONT_SIZE))
        postScore.font = postScore.font.withSize(CGFloat(MEDIUM_FONT_SIZE))
        postTitle.font = postTitle.font.withSize(CGFloat(MEDIUM_FONT_SIZE))
        postSubmitter.font = postSubmitter.font.withSize(CGFloat(SMALL_FONT_SIZE))
        postTime.font = postTime.font.withSize(CGFloat(SMALL_FONT_SIZE))
        postNumberOfComments.font = postNumberOfComments.font.withSize(CGFloat(SMALL_FONT_SIZE))
    }

    func assignFontColors() {
        subredditTitle.textColor = .gray
        postScore.textColor = .black
        postTitle.textColor = .black
        postSubmitter.textColor = .gray
        postTime.textColor = .gray
        postNumberOfComments.textColor = .gray
    }

    func makingTranslationFalse() {
        postImage.translatesAutoresizingMaskIntoConstraints = false
        subredditTitle.translatesAutoresizingMaskIntoConstraints = false
        postScore.translatesAutoresizingMaskIntoConstraints = false
        postTitle.translatesAutoresizingMaskIntoConstraints = false
        postSubmitter.translatesAutoresizingMaskIntoConstraints = false
        postTime.translatesAutoresizingMaskIntoConstraints = false
        postNumberOfComments.translatesAutoresizingMaskIntoConstraints = false
    }

    func addConstraintsToViews() {
        let viewsDict = [
            "postImage" : postImage,
            "subredditTitle" : subredditTitle,
            "postScore" : postScore,
            "postTitle" : postTitle,
            "postSubmitter" : postSubmitter,
            "postNumberOfComments" : postNumberOfComments,
            "postTime" : postTime,
            "superview": self.contentView
        ]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[postScore]-[subredditTitle]-(>=92)-|", options: [.alignAllCenterY], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[postTitle]-(>=92)-|", options: [], metrics: nil, views: viewsDict))

        // https://github.com/evgenyneu/center-vfl
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[superview]-(<=1)-[postImage(75)]-12-|", options: [.alignAllCenterY], metrics: nil, views: viewsDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[postSubmitter]-4-[postNumberOfComments]-(>=90)-|", options: [.alignAllCenterY], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[postTime]-(>=92)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[postScore]-[postTitle]-6-[postSubmitter]-6-[postTime]-6-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[postImage(75)]", options: [], metrics: nil, views: viewsDict))
    }

    // https://stackoverflow.com/a/51132959
    // Offers dynamic height of cell
    override func updateConstraints() {
        widthConstraint?.constant = superview!.bounds.width - CGFloat(16)
        widthConstraint?.isActive = true
        super.updateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}
