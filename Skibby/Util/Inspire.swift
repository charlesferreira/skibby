//
//  Inspire.swift
//  Skibby
//
//  Created by Charles Ferreira on 26/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

struct Inspire {
    
    static let data = [
        "Que tal uma frase inspiradora?",
        "Como está o seu dia?",
        "Que música você está ouvindo?",
        "Como você está?",
        "Algum recado para os seus vizinhos?",
        "Era uma vez...",
        "Tem algum bom filme para sugerir?",
        "Solte o verbo!",
        "Mande uma mensagem positiva :)",
    ]
    
    private init() {}
    
    static func random() -> String {
        let index = Int(arc4random()) % data.count
        return data[index]
    }
    
}
