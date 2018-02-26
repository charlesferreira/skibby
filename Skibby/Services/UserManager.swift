//
//  User.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase
import CoreLocation

protocol UserManagerDelegate: AnyObject {
    func userManager(_ manager: UserManager, didCollectMessage message: Message)
}

class UserManager {
    
    weak var delegate: UserManagerDelegate?
    
    private (set) var uid: String?
    
    private (set) var newCollectedMessages = [String]()
    private var allCollectedMessages = [String]()
    
    static func sharedManager() -> UserManager {
        struct Static { static let instance = UserManager() }
        return Static.instance
    }
    
    private init() {
        // tenta carregar a ID do usuário do UserDefaults
        let keyForUID = Constants.userDefaults.keyForUID
        if let uid = UserDefaults.standard.string(forKey: keyForUID) {
            self.uid = uid
        }
        
        // tenta carregar a lista de mensagens do UserDefaults
        let keyForMessages = Constants.userDefaults.keyForMessages
        if let messages = UserDefaults.standard.array(forKey: keyForMessages) as? [String] {
            //collectedMessages = messages
            print("TODO: descomentar linha acima para carregar mensagens do UserDefaults")
        }
    }
    
    func logIn() {
        guard uid == nil else { return }
        
        // autentica no Firebase e armazena o ID do usuário no UserDefaults
        Auth.auth().signInAnonymously { (user, error) in
            guard error == nil, let user = user else {
                fatalError(Errors.firebase.didFailToSignIn(with: error))
            }
            
            self.uid = user.uid
            let keyForUID = Constants.userDefaults.keyForUID
            UserDefaults.standard.set(self.uid, forKey: keyForUID)
        }
    }
    
    func collect(_ message: Message) {
        guard canCollect(message: message) else { return }
        
        newCollectedMessages.append(message.id!)
        allCollectedMessages.append(message.id!)
        updateUserDefaults()
        
        delegate?.userManager(self, didCollectMessage: message)
    }
    
    func canCollect(message: Message) -> Bool {
        // descarta mensagens de própria autoria
        guard message.senderID != uid else { return false }
        
        // descarta mensagens já coletadas
        guard let messageID = message.id, !allCollectedMessages.contains(messageID) else { return false }
        
        return true
    }
    
    private func updateUserDefaults() {
        let keyForMessages = Constants.userDefaults.keyForMessages
        UserDefaults.standard.set(allCollectedMessages, forKey: keyForMessages)
    }
}
