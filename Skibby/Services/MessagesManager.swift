//
//  MessagesManager.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase

class MessagesManager {
    
    static func sharedManager() -> MessagesManager {
        struct Static { static let instance = MessagesManager() }
        return Static.instance
    }
    
    private var messages = [String: Message]()
    
    private init() {}
    
    func loadMessage(identifiedBy messageID: String, completion: @escaping ((Message) -> Void)) {
        // retorna da memória
        if let message = messages[messageID] {
            completion(message)
            return
        }
        
        // busca no Firebase
        let ref = Database.database().reference(withPath: Constants.messages.allMessagesPath)
        ref.child(messageID).observeSingleEvent(of: .value) { (snapshot) in
            let message = Message.createFromSnapshot(snapshot)
            self.messages[messageID] = message
            completion(message)
        }
    }
    
}
