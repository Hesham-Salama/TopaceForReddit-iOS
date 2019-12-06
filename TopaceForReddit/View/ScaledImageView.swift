//
//  ScaledtImageView.swift
//  TopaceForReddit
//
//  Created by hesham on 12/10/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit

// https://stackoverflow.com/a/48937190/
class ScaledImageView: UIImageView {

    override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
}
