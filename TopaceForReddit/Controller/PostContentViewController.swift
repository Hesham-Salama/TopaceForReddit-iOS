//
//  PostContentViewController.swift
//  TopaceForReddit
//
//  Created by hesham on 11/21/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import Kingfisher

class PostContentViewController: UIViewController {

    var navTitle = ""
    private let backgroundPicName = "main_bg"
    private var postFrame : CGRect
    private var postData : PostData?
    private var index : Int
    private var image: UIImage?
    private var postContentViews : PostContentViews?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        self.view.insertSubview(ViewsUtil.constructBgFromImage(imageName: backgroundPicName), at: 0)
        postContentViews = PostContentViews(view: view, postFrame: postFrame)
        makePostView()
        attachPostText()
        attachPostImage()
    }

    init(postDetails: PostData?, index : Int, frame: CGRect, image: UIImage?) {
        postFrame = frame
        postData = postDetails
        self.index = index
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        showSaveImageAlert()
    }

    func makePostView() {
        postContentViews!.postView = CellViewUtil.prepareCell(postData: postData, index: index, image: image, myCell: postContentViews!.postView as! RedditPostCollectionViewCell)
    }

    func attachPostText() {
        if let text = postData?.data.children[index].data.mSelfText_HTML {
            postContentViews?.makeTextPost(text: text)
        }
    }

    func attachPostImage() {
        if let imageUrl = postData?.data.children[index].data.preview?.images[0].source.url {
            self.postContentViews?.makeImagePost()
            downloadImage(url: imageUrl) {
                [weak self]image in
                if let image = image {
                    self?.postContentViews?.setImage(image: image)
                    self?.postContentViews?.imagePost?.isUserInteractionEnabled = true
                    self?.postContentViews?.imagePost?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.imageTapped)))
                }
            }
        }
    }

    func downloadImage(url : String, completionHandler: @escaping ((UIImage?) -> Void)) {
        if let urlObj = URL(string: url) {
            KingfisherManager.shared.retrieveImage(with: urlObj, options: nil, progressBlock: nil, completionHandler: { gottenImage, _, _, _ in
                completionHandler(gottenImage)
            })
        } else {
            completionHandler(nil)
        }
    }

    override func viewDidLayoutSubviews() {
        if let imagePost = self.postContentViews?.imagePost {
            imagePost.layoutIfNeeded()
            imagePost.invalidateIntrinsicContentSize()
        }
    }
    
    func showSaveImageAlert() {
        let alert = UIAlertController(title: "Save Image", message: "Would you like to save this image to photos library?", preferredStyle: UIAlertController.Style.alert)
        
        let alertSaveAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (alertAction) in
            if let image = self.postContentViews?.imagePost?.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        
        alert.addAction(alertSaveAction)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
