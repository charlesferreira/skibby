//
//  Errors.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct Errors {
    
    static let location = Location()
    static let firebase = Firebase()
    static let user = User()
    
    private init() {}
}

extension Errors {
    struct Location {
        func didFail(with error: Error) -> String {
            return "Erro ao processar localização: \(error)"
        }
    }
    
    struct Firebase {
        func didFailToSignIn(with error: Error?) -> String {
            return "Não foi possível autenticar anonimamente: \(String(describing: error))"
        }
    }
    
    struct User {
        var idNotSet: String {
            return "Necessário acessar ID do usuário, porém o valor não existe"
        }
    }
}
