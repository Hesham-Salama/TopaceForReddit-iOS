//
//  AddSubredditController.swift
//  TopaceForReddit
//
//  Created by hesham on 11/14/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit

class AddSubredditController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var addSubredditTextField: UITextField!
    @IBOutlet weak var saveOptionPicker: UIPickerView!
    @IBOutlet weak var saveNumberPostsPicker: UIPickerView!
    let addSubredditData = AddSubredditData()
    var selectedSaveOption = ""
    var selectedNumberOfPosts = ""
    let UNWIND_ID = "unwindToVC"
    let SAVE_OPTIONS_TAG = 1
    var subredditsNames = [String]()
    var network : Network?
    var subredditFetchable : SubredditFetchableProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializePickers()
        hideKeyboardWhenTappedAround()
        network = Network()
        let coreDataHandler = CoreDataHandler()
        subredditsNames = coreDataHandler.subredditNames
    }

    func initializePickers() {
        saveOptionPicker.delegate = self
        saveOptionPicker.dataSource = self
        saveOptionPicker.selectRow(0, inComponent: 0, animated: true)
        saveOptionPicker.tag = SAVE_OPTIONS_TAG
        saveNumberPostsPicker.delegate = self
        saveNumberPostsPicker.dataSource = self
        saveNumberPostsPicker.selectRow(0, inComponent: 0, animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == SAVE_OPTIONS_TAG {
            return addSubredditData.saveOptions.count
        } else {
            return addSubredditData.numPostsToSave.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == SAVE_OPTIONS_TAG {
            selectedSaveOption = addSubredditData.saveOptions[row]
        } else {
            selectedNumberOfPosts = addSubredditData.numPostsToSave[row]
        }
    }

    // https://stackoverflow.com/a/48744047/
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        var label = UILabel()
        if let v = view as? UILabel {
            label = v
        }
        if pickerView.tag == SAVE_OPTIONS_TAG {
            label.text = addSubredditData.saveOptions[row]
            label.font = UIFont.systemFont(ofSize: 15)
        } else {
            label.text = addSubredditData.numPostsToSave[row]
        }
        label.textAlignment = .center
        return label
    }

    @IBAction func addSubredditClicked(_ sender: UIButton) {
        //check if there is internet connection
        //check if subreddit exists
        //check if it is NSFW
        //check if it is duplicate either in active or archived
        //check if it is downloading
        //check blank spaces
        //Check: banned
        //Check: want save subreddit but it's empty
        //check if it is alphabetic
        let subredditName = addSubredditTextField.text
        if let subreddit = subredditName {
            if isActiveSubredditDuplicate(subreddit: subreddit) {
                displayMessage(message: addSubredditData.DUPLICATE_ACTIVE_MSG)
                return
            }
            if subreddit.isEmptyOrWhitespace {
                displayMessage(message: addSubredditData.EMPTY_WHITESPACE_MSG)
                return
            }
            if !subreddit.isAlphanumeric {
                displayMessage(message: addSubredditData.ALPHANUMERIC_MSG)
                return
            }
            var redditURL = RedditURL()
            redditURL.addSubreddits(subreddits: subreddit)
            redditURL.addLimit(lim: RedditURL.limit.limit_1)
            network?.downloadPosts(redditURL: redditURL) {
                [weak self] downloadStatus in
                guard let self = self else {return}
                if downloadStatus != Network.downloadStatus.success {
                    DispatchQueue.main.async {
                        self.displayMessage(message: self.addSubredditData.WEAK_OR_NO_INTERNET_MESSAGE)
                        return
                    }
                }
                if !self.doesSubredditExist {
                    DispatchQueue.main.async {
                        self.displayMessage(message: self.addSubredditData.SUBREDDIT_DOESNT_EXIST_MSG)
                        return
                    }
                }
                else if self.isSubredditBanned {
                    DispatchQueue.main.async {
                        self.displayMessage(message: self.addSubredditData.SUBREDDIT_BANNED_MSG)
                        return
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        self.subredditFetchable?.sendSubredditName(subredditName: subreddit)
                    }
                }
            }
        } else {
            displayMessage(message: addSubredditData.EMPTY_WHITESPACE_MSG)
        }
    }

    var isSubredditBanned : Bool {
        if let jsonData = self.network?.dataJSON {
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    if let val = jsonResponse["reason"] as? String, val == "banned" {
                        return true
                    }
                }
            }
            catch let parsingError {
                print("Error:AddSubredditController:doesSubredditExist", parsingError)
            }
        }
        return false
    }
    var doesSubredditExist : Bool {
        if let jsonData = self.network?.dataJSON {
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    let data = jsonResponse["data"] as? [String: Any]
                    let after = data?["after"] as? String
                    if after != nil && after != "" {
                        return true
                    }
                }
            } catch let parsingError {
                print("Error:AddSubredditController:doesSubredditExist", parsingError)
            }
        }
        return false
    }

    func isActiveSubredditDuplicate(subreddit: String) -> Bool {
        if subreddit == "popular" || subreddit == "all" {
            return true
        }
        for subName in subredditsNames {
            if subName == subreddit {
                return true
            }
        }
        return false
    }

    // https://stackoverflow.com/a/51059019/
    func displayMessage(message: String) {
        let alertDisapperTimeInSeconds = 2.5
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
            alert.dismiss(animated: true)
        }
    }
}

// https://stackoverflow.com/a/52471181/
extension String {
    var isEmptyOrWhitespace : Bool {
        if isEmpty {
            return true
        }
        return trimmingCharacters(in: NSCharacterSet.whitespaces) == ""
    }

    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
// https://stackoverflow.com/a/48592991
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
