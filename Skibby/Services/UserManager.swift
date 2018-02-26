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
    
    private (set) var ownMessages = [String: Date]()
    private (set) var allCollectedMessages = [String: Date]()
    private (set) var newCollectedMessages = [String]()
    
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
        let keyForAllMessages = Constants.userDefaults.keyForAllMessages
        if let messages = UserDefaults.standard.dictionary(forKey: keyForAllMessages) as? [String: Date] {
            //collectedMessages = messages
            print("TODO: descomentar linha acima para carregar mensagens do UserDefaults")
        }
        
        // tenta carregar a lista de mensagens do UserDefaults
        let keyForOwnMessages = Constants.userDefaults.keyForOwnMessages
        if let messages = UserDefaults.standard.dictionary(forKey: keyForOwnMessages) as? [String: Date] {
            ownMessages = messages
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
    
    func save(newMessage message: Message) {
        if let messageID = message.id {
            ownMessages[messageID] = Date()
            updateUserDefaults()
        }
    }
    
    func collect(_ message: Message) -> Bool {
        guard canCollect(message: message) else { return false }
        
        newCollectedMessages.append(message.id!)
        allCollectedMessages[message.id!] = Date()
        updateUserDefaults()
        
        delegate?.userManager(self, didCollectMessage: message)
        
        return true
    }
    
    func canCollect(message: Message) -> Bool {
        // descarta mensagens de própria autoria
        guard message.senderID != uid else { return false }

        // descarta mensagens já coletadas
        guard let messageID = message.id, allCollectedMessages[messageID] == nil else {
            return false
        }
        
        return true
    }
    
    private func updateUserDefaults() {
        let keyForAllMessages = Constants.userDefaults.keyForAllMessages
        let keyForOwnMessages = Constants.userDefaults.keyForOwnMessages
        UserDefaults.standard.set(allCollectedMessages, forKey: keyForAllMessages)
        UserDefaults.standard.set(ownMessages, forKey: keyForOwnMessages)
    }
}
