//
//  Menu.swift
//  TopaceForReddit
//
//  Created by hesham on 11/21/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import SideMenu

struct Menu {

    let viewController : UIViewController?
    var menuLeftNavigationController: UISideMenuNavigationController?

    init(vc : UIViewController?) {
        viewController = vc
        initMenu()
    }

    mutating func initMenu() {
        if let viewController = viewController {
            menuLeftNavigationController = viewController.storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
            menuLeftNavigationController?.leftSide = true
            SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
            // (Optional) Enable gestures. The left and/or right menus must be set up above for these to work.
            // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
            SideMenuManager.default.menuAddPanGestureToPresent(toView: viewController.navigationController!.navigationBar)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: viewController.navigationController!.view)
            // (Optional) Prevent status bar area from turning black when menu appears:
            SideMenuManager.default.menuFadeStatusBar = false
            SideMenuManager.default.menuPresentMode = .viewSlideOut
        }
    }

    func addDelegate() {
        if let vc = viewController as? MainController {
            let tableMenuVC = menuLeftNavigationController?.viewControllers.first as? SideMenuTableViewController
            tableMenuVC?.delegate = vc
        }
    }
    
    func deleteSubreddit(subredditName: String) {
        let tableMenuVC = menuLeftNavigationController?.viewControllers.first as? SideMenuTableViewController
        tableMenuVC?.removeSubredditAndReload(subredditName: subredditName)
    }

    func showNavMenu() {
        viewController?.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    func hideNavMenu() {
        SideMenuManager.default.menuLeftNavigationController!.dismiss(animated: true, completion: nil)
    }
}
