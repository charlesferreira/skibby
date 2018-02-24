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
    
    let locationManager = CLLocationManager()
    
    @IBAction func composeMessageTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Nova Mensagem", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "No meu local atual", style: .default) { (_) in
            self.composeMessage()
        })
        
        alert.addAction(UIAlertAction(title: "Selecionar local", style: .default) { (_) in
            print("Select location")
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func composeMessage() {
        guard let location = locationManager.location else { return }
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ComposeMessageViewController") as? ComposeMessageViewController else { return }
        
        controller.location = location
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
