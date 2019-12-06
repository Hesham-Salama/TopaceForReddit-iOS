//
//  PostContentViews.swift
//  TopaceForReddit
//
//  Created by hesham on 11/27/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import Kingfisher

// inspired by https://stackoverflow.com/a/43452089/
struct PostContentViews {

    private var textPost: UILabel?
    var postView : UIView?
    var imagePost : ScaledImageView?
    private let view : UIView
    private let contentView : UIView
    private let scrollView: UIScrollView
    private var bottomConstraintToMainView : NSLayoutConstraint?


    init(view: UIView, postFrame: CGRect) {
        self.view = view
        postView = RedditPostCollectionViewCell(frame: postFrame)
        scrollView = {
            let v = UIScrollView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addAndAttachScrollView()
        addAndAttachContentView()
        addAndAttachPostView()
    }

    private func addAndAttachScrollView() {
        self.view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
    }

    private func addAndAttachContentView() {
        scrollView.addSubview(contentView)
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        // both constraints are important.
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func addAndAttachPostView() {
        postView?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postView!)
        let heightOfPostHeader = postView!.frame.size.height
        NSLayoutConstraint(item: postView!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 8).isActive = true
        NSLayoutConstraint(item: postView!, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -8).isActive = true
        NSLayoutConstraint(item: postView!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 8).isActive = true
        postView!.heightAnchor.constraint(equalToConstant: heightOfPostHeader).isActive = true
    }

    mutating func makeTextPost(text: String) {
        textPost = BorderedLabel(textStr: text)
        textPost!.translatesAutoresizingMaskIntoConstraints = false
        attachPostText()
    }

    private mutating func attachPostText() {
        contentView.addSubview(textPost!)
        NSLayoutConstraint(item: textPost!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 8).isActive = true
        NSLayoutConstraint(item: textPost!, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -8).isActive = true
        NSLayoutConstraint(item: textPost!, attribute: .top, relatedBy: .equal, toItem: postView, attribute: .bottom, multiplier: 1.0, constant: 12).isActive = true
        // the most important constraint.
        bottomConstraintToMainView = NSLayoutConstraint(item: textPost!, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8)
        bottomConstraintToMainView?.isActive = true
    }
    
    mutating func makeImagePost() {
        imagePost = ScaledImageView()
//        imagePost?.image = image
        imagePost?.contentMode = .scaleAspectFit
        imagePost?.translatesAutoresizingMaskIntoConstraints = false
        attachImageView()
    }

    private mutating func attachImageView() {
        if let imagePost = imagePost {
            contentView.addSubview(imagePost)
            imagePost.heightAnchor.constraint(equalToConstant: CGFloat(30))
            NSLayoutConstraint(item: imagePost, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 8).isActive = true
            NSLayoutConstraint(item: imagePost, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -8).isActive = true
            if textPost != nil {
                NSLayoutConstraint(item: imagePost, attribute: .top, relatedBy: .equal, toItem: textPost, attribute: .bottom, multiplier: 1.0, constant: 12).isActive = true
            } else {
                NSLayoutConstraint(item: imagePost, attribute: .top, relatedBy: .equal, toItem: postView, attribute: .bottom, multiplier: 1.0, constant: 12).isActive = true
            }
            bottomConstraintToMainView?.isActive = false
            bottomConstraintToMainView = NSLayoutConstraint(item: imagePost, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8)
            bottomConstraintToMainView?.isActive = true
        }
    }

    mutating func setImage(image: UIImage) {
        imagePost?.image = image
    }
}
