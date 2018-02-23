//
//  Errors.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct Errors {
    
    static let location = Location()
    
    private init() {}
}

extension Errors {
    struct Location {
        func didFail(with error: Error) -> String {
            return "Erro ao processar localização: \(error)"
        }
    }
}
