//
//  HelperViews.swift
//  TopaceForReddit
//
//  Created by hesham on 11/22/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit

class ViewsUtil {

    static func constructBgFromImage(imageName : String) -> UIImageView {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        return backgroundImage
    }
}
