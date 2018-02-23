//
//  User.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct User {
    
    private (set) static var shared: User!
    
    var id: String
    
    static func configure(id: String) {
        shared = User(id: id)
    }
    
}
