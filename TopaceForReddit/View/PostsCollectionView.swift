//
//  PostsCollectionView.swift
//  TopaceForReddit
//
//  Created by hesham on 11/21/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit

class PostsCollectionView {

    private let myCollectionView : UICollectionView?
    static let COLLECTION_VIEW_ITEM_ID = "MyCell"

    init(viewController : UIViewController) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 8)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        myCollectionView = UICollectionView(frame: viewController.view.frame, collectionViewLayout: layout)
        myCollectionView?.dataSource = viewController as? UICollectionViewDataSource
        myCollectionView?.delegate = viewController as? UICollectionViewDelegate
        myCollectionView?.backgroundColor = .clear
        myCollectionView?.register(RedditPostCollectionViewCell.self, forCellWithReuseIdentifier: PostsCollectionView.COLLECTION_VIEW_ITEM_ID)
    }

    var constructedCollectionView : UICollectionView? {
        return myCollectionView
    }
}
