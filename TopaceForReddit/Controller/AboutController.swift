//
//  AboutController.swift
//  TopaceForReddit
//
//  Created by hesham on 11/14/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    let navTitle = "About"
    let backgroundPicName = "main_bg"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        self.view.insertSubview(ViewsUtil.constructBgFromImage(imageName: backgroundPicName), at: 0)
    }
}