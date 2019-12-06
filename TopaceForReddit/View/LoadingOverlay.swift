//
//  LoadingOverlay.swift
//  TopaceForReddit
//
//  Created by hesham on 11/26/18.
//  Copyright © 2018 hesham. All rights reserved.
//
import UIKit

// https://stackoverflow.com/a/34268704/
struct LoadingOverlay {

    let alert : UIAlertController?

    init() {
        alert = UIAlertController(title: nil, message: "Loading posts...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        alert?.view.addSubview(loadingIndicator)
    }
}
