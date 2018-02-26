//
//  SettingsViewController.swift
//  Skibby
//
//  Created by Charles Ferreira on 26/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var showOwnMessages: UISwitch!
    @IBOutlet weak var showCollectedMessages: UISwitch!
    @IBOutlet weak var filterNSFW: UISwitch!
    
    var showNSFW: Bool {
        return UserDefaults.standard.bool(forKey: Constants.userDefaults.showNSFW)
    }
    
    var hideOwnMessages: Bool {
        return UserDefaults.standard.bool(forKey: Constants.userDefaults.hideOwnMessages)
    }
    
    var hideCollectedMessages: Bool {
        return UserDefaults.standard.bool(forKey: Constants.userDefaults.hideCollectedMessages)
    }
    
    override func viewDidLoad() {
        updateSwitches()
    }
    
    private func updateSwitches() {
        showOwnMessages.isOn = !hideOwnMessages
        showCollectedMessages.isOn = !hideCollectedMessages
        filterNSFW.isOn = !showNSFW
    }
    
    private func updatePreferences() {
        UserDefaults.standard.set(!showOwnMessages.isOn, forKey: Constants.userDefaults.hideOwnMessages)
        UserDefaults.standard.set(!showCollectedMessages.isOn, forKey: Constants.userDefaults.hideCollectedMessages)
        UserDefaults.standard.set(!filterNSFW.isOn, forKey: Constants.userDefaults.showNSFW)
    }
    
    @IBAction func toggleSwitch(_ sender: Any) {
        updatePreferences()
    }
}
