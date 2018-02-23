//
//  AppDelegate.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        signInAnonymously()
        
        return true
    }
    
    // autentica o usuário configura a instância compartilhada
    func signInAnonymously() {
        Auth.auth().signInAnonymously { (user, error) in
            guard error == nil, let user = user else {
                fatalError("Não foi possível autenticar anonimamente: \(error!)")
            }
            
            User.configure(id: user.uid)
        }
    }

}

