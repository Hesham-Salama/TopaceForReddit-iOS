//
//  SideMenuTableViewController.swift
//  TopaceForReddit
//
//  Created by hesham on 11/12/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit

protocol SubredditFetchableProtocol {
    func sendSubredditName(subredditName: String)
}
class SideMenuTableViewController: UITableViewController, SubredditFetchableProtocol {

    // Weak references are only valid in classes. By inheriting from NSObjectProtocol your are guaranteeing to the compiler that the protocol will only be used for classes
    weak var delegate: MainCntProtocol?
    var cdHandler : CoreDataHandler?
    var subsNames = [String]()
    let ADD_SUBREDDIT_SEGUE_ID = "toAddSubredditID"
    let LAUNCHED_BEFORE_TAG = "launchedBefore"

    override func viewDidLoad() {
        super.viewDidLoad()
        // initializing it as an empty tableview, making it remove the extra lines from default.
        tableView.tableFooterView = UIView()
        cdHandler = CoreDataHandler()
        let launchedBefore = UserDefaults.standard.bool(forKey: LAUNCHED_BEFORE_TAG)
        if !launchedBefore {
            cdHandler?.saveSubredditNames(names: ["popular"])
            UserDefaults.standard.set(true, forKey: LAUNCHED_BEFORE_TAG)
        }
        subsNames = cdHandler?.subredditNames ?? [String]()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return subsNames.count
        case 2:
            return 2
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Add a subreddit"
        case 1:
            return "Subreddits"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        var textInLabel : String
        switch indexPath.section {
        case 0:
            textInLabel = "Add"
        case 1:
            textInLabel = subsNames[indexPath.row]
        case 2:
            if indexPath.row == 0 {
                textInLabel = "Saved posts"
            }
            else {
                textInLabel = "About"
            }
        default:
            textInLabel = ""
        }
        cell.textLabel?.text = textInLabel
        //        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            //            presentVCInNavController(refVC: AddSubredditController())
            performSegue(withIdentifier: ADD_SUBREDDIT_SEGUE_ID, sender: nil)
        case 1:
            delegate?.repopulateCollectionView(subredditNames: pickSubredditToBrowse(indexPath: indexPath))
        case 2:
            if indexPath.row == 0 {
                presentVCInNavController(refVC: SavedPostsController())
            }
            else {
                presentVCInNavController(refVC: AboutController())
            }
        default:
            print("didSelectRowAt fails.")
        }
    }

    func pickSubredditToBrowse(indexPath: IndexPath) -> [String] {
        let subredditName = subsNames[indexPath.row]
        if subredditName.lowercased() == "all" {
            var tempSubs = subsNames
            tempSubs.removeFirst()
            tempSubs.removeFirst()
            return tempSubs
        }
        return [subredditName]
    }

    func presentVCInNavController(refVC: UIViewController) {
        self.navigationController?.pushViewController(refVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ADD_SUBREDDIT_SEGUE_ID {
            if let destinationVC = segue.destination as? AddSubredditController {
                destinationVC.subredditFetchable = self
            }
        }
    }

    func sendSubredditName(subredditName: String) {
        appendSubreddit(subredditName: subredditName)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.delegate?.repopulateCollectionView(subredditNames: [subredditName])
        }
    }
    
    private func appendSubreddit(subredditName : String) {
        let subreddits = cdHandler?.subredditNames
        cdHandler?.deleteSubredditNames()
        if var subreddits = subreddits {
            subreddits.append(subredditName)
            if subreddits.count == 3 {
                // add All.
                subreddits.insert("All", at: 1)
            }
            cdHandler?.saveSubredditNames(names: subreddits)
        }
        subsNames = cdHandler?.subredditNames ?? [String]()
    }
    
    func removeSubredditAndReload(subredditName: String) {
        removeSubreddit(subredditName: subredditName)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func removeSubreddit(subredditName : String) {
        let subreddits = cdHandler?.subredditNames
        cdHandler?.deleteSubredditNames()
        if var subreddits = subreddits {
            for index in 0...subreddits.count - 1 {
                if subreddits[index] == subredditName {
                    subreddits.remove(at: index)
                }
            }
            cdHandler?.saveSubredditNames(names: subreddits)
        }
        subsNames = cdHandler?.subredditNames ?? [String]()
    }
}
