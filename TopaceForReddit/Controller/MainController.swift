//
//  MainController.swift
//  TopaceForReddit
//
//  Created by hesham on 11/12/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit

protocol MainCntProtocol: NSObjectProtocol {
    func repopulateCollectionView(subredditNames: [String])
}

class MainController : UIViewController, MainCntProtocol {
    
    var postData : PostData? = nil
    let networkObj = Network()
    var menu : Menu? = nil
    var postsCV : PostsCollectionView? = nil
    let loadingOverloay = LoadingOverlay()
    var currentData = CurrentRedditData()
    var isLoading = false
    var scrollViewPosition : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = Menu(vc: self)
        menu?.addDelegate()
        postsCV = PostsCollectionView(viewController: self)
        makeAndRegisterCollectionView()
        downloadAndSetPostsData()
    }
    
    @IBAction func showNavMenu(_ sender: UIBarButtonItem) {
        menu?.showNavMenu()
    }
    
    func downloadAndSetPostsData() {
        isLoading = true
        present(loadingOverloay.alert!, animated: true, completion: nil)
        networkObj.downloadPosts(redditURL: currentData.redditURL) {
            [weak self]
            downloadStatus in
            guard let self = self else {return}
            if downloadStatus == .success {
                self.networkObj.decodeJSONAndSetPosts()
                DispatchQueue.main.async {
                    if let collectionView = self.postsCV?.constructedCollectionView,
                        let tempPostData = self.networkObj.getPostData() {
                        if self.postData == nil {
                            self.postData = tempPostData
                            collectionView.reloadData()
                            collectionView.layoutIfNeeded()
                        } else {
                            let lastIdx = self.postData!.data.children.count
                            for (index,item) in tempPostData.data.children.enumerated() {
                                self.postData?.data.children.append(item)
                                let indexPath = IndexPath(item: lastIdx+index, section: 0)
                                collectionView.insertItems(at: [indexPath])
                            }
                        }
                        if let postData = self.postData {
                            let lastIdx = postData.data.children.count - 1
                            self.currentData.setID(lastID: postData.data.children[lastIdx].data.mID ?? nil)
                        }
                    }
                    self.finishLoading()
                }
            } else {
                // download failed
                DispatchQueue.main.async {
                    self.finishLoading()
                }
            }
        }
    }
    
    func finishLoading() {
        if let position = scrollViewPosition {
            postsCV?.constructedCollectionView?.setContentOffset(position, animated: false)
        } else {
            postsCV?.constructedCollectionView?.scrollToTop(false)
        }
        isLoading = false
        dismiss(animated: false, completion: nil)
    }
    
    
    func navigateToDetails(postData : PostData?, index : Int, postFrame : CGRect, image: UIImage?) {
        let postContentVC = PostContentViewController(postDetails: postData, index: index, frame: postFrame, image: image)
        postContentVC.navTitle = "Topace for Reddit"
        self.navigationController?.pushViewController(postContentVC, animated: true)
    }
    
    func repopulateCollectionView(subredditNames: [String]) {
        currentData.clear()
        currentData.setTitle(subredditNames: subredditNames)
        currentData.setID(lastID: nil)
        menu?.hideNavMenu()
        resetAndDownloadPosts()
    }
    
    func resetAndDownloadPosts() {
        self.scrollViewPosition = nil
        self.postData = nil
        self.downloadAndSetPostsData()
    }
    
    func makeAndRegisterCollectionView() {
        if let collectionView = postsCV?.constructedCollectionView {
            self.view.addSubview(collectionView)
        }
    }
    
    @IBAction func showActionSheetButton(_ sender: UIBarButtonItem) {
        let title = self.currentData.getSubredditTitle()
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        var alertActions = [UIAlertAction]()
        let dictIndexSortType = ["Sort: Hot", "Sort: New", "Sort: Top - Day",
                                 "Sort: Top - Week", "Sort: Top - Month", "Sort: Top - Year",
                                 "Sort: Top - All"]
        for index in 0...dictIndexSortType.count - 1 {
            let alertAction = UIAlertAction(title: dictIndexSortType[index], style: .default) {
                (alertAction) in
                self.currentData.clear()
                self.currentData.setTitle(subredditNames: [title])
                // Value index IS CAPTURED.
                switch index {
                    case 1: self.currentData.setSortAttr(sortInterval: .new)
                    case 2: self.currentData.setSortAttr(sortInterval: .day)
                    case 3: self.currentData.setSortAttr(sortInterval: .week)
                    case 4: self.currentData.setSortAttr(sortInterval: .month)
                    case 5: self.currentData.setSortAttr(sortInterval: .year)
                    case 6: self.currentData.setSortAttr(sortInterval: .all)
                    default: break
                }
                self.resetAndDownloadPosts()
            }
            alertActions.append(alertAction)
      }
        
        let deleteAction = UIAlertAction(title: "Delete Subreddit", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            self.menu?.deleteSubreddit(subredditName: title)
            self.currentData.clear()
            self.currentData.setTitle(subredditNames: ["popular"])
            self.resetAndDownloadPosts()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        for alertAction in alertActions {
            alertController.addAction(alertAction)
        }
        if !title.lowercased().contains("+") && title.lowercased() != "popular" {
            alertController.addAction(deleteAction)
        }
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = postData?.data.children.count {
            print(count)
            return count
        } else {
            print("Error (numberOfItemsInSection): No items.")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsCollectionView.COLLECTION_VIEW_ITEM_ID, for: indexPath as IndexPath) as! RedditPostCollectionViewCell
        return CellViewUtil.prepareCell(postData: postData, index: indexPath.row,
                                        image: nil, myCell: myCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let pickedView = collectionView.cellForItem(at: indexPath) {
            let view = pickedView as? RedditPostCollectionViewCell
            navigateToDetails(postData: postData, index : indexPath.row, postFrame: pickedView.frame, image: view?.postImage.image)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            && scrollView.contentOffset.y > 0 && !isLoading) {
            scrollViewPosition = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
            downloadAndSetPostsData()
        }
    }
    
    func resetScrollPositionToTop() {
        if let collectionView = self.postsCV?.constructedCollectionView {
            let contentOffset = CGPoint(x:0, y: -collectionView.contentInset.top)
            collectionView.setContentOffset(contentOffset, animated: false)
        }
    }
}

extension UIScrollView {
    func scrollToTop(_ animated: Bool) {
        var topContentOffset: CGPoint
        if #available(iOS 11.0, *) {
            topContentOffset = CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top)
        } else {
            topContentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
        }
        setContentOffset(topContentOffset, animated: animated)
    }
}
