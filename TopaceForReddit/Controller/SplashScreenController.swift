//
//  SplashScreenController.swift
//  TopaceForReddit
//
//  Created by hesham on 11/11/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import UserNotifications

class SplashScreenController: UIViewController {

    let SEGUE_ID = "splash_to_main"
    @IBOutlet var loadingLabel: UILabel!

    override func viewDidLoad() {
        loadingLabel.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            _,_ in
        })
        waitBeforeSegue()
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: SEGUE_ID, sender: nil)
    }

    func waitBeforeSegue(){
        Thread.sleep(forTimeInterval: 2.0) //in seconds
        // Here there should be some dialog for ads' consent in European countries
        //Leaving it for the future.
        loadingLabel.isHidden = false
    }
    
    deinit {
        print("SplashScreen deallocated successfully")
    }
}
