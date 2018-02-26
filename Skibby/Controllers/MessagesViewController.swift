//
//  MessagesViewController.swift
//  Skibby
//
//  Created by Charles Ferreira on 23/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import CoreLocation

class MessagesViewController: UITableViewController {
    
    @IBOutlet weak var ownershipFilter: UISegmentedControl!
    
    override func viewDidLoad() {
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.customDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let manager = UserManager.sharedManager()
        switch ownershipFilter.selectedSegmentIndex {
        case 1:
            return manager.ownMessages.count
        default:
            return manager.allCollectedMessages.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "MessageTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageTableViewCell
        if cell == nil {
            cell = MessageTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        let messageInfo = self.messageInfo(forRowAt: indexPath)
        MessagesManager.sharedManager().loadMessage(identifiedBy: messageInfo.key, completion: { (message) in
            cell?.setup(forMessage: message, date: messageInfo.value)
        })
        
        return cell!
    }
    
    func messageInfo(forRowAt indexPath: IndexPath) -> (key: String, value: Date) {
        let manager = UserManager.sharedManager()
        let messages = ownershipFilter.selectedSegmentIndex == 0 ? manager.allCollectedMessages : manager.ownMessages
        let messagesArray = messages.sorted { $0.value > $1.value }
        return messagesArray[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMessage", sender: indexPath)
    }
    
    @IBAction func toggleOwnershipFilter() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ShowMessageController,
            let indexPath = sender as? IndexPath {
            let messageInfo = self.messageInfo(forRowAt: indexPath)
            controller.messageID = messageInfo.key
        }
    }
}

extension MessagesViewController: TabBarControllerDelegate {
    func tabBar(_ tabBar: TabBarController, didUpdateMessagesBadge badgeValue: String?) {
        tableView.reloadData()
    }
}
