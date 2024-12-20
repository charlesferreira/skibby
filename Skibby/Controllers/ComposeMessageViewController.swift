//
//  ComposeMessageViewController.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import CoreLocation
import GrowingTextView

class ComposeMessageViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var warningButton: UIView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    let nsfwModel = Nudity()
    
    var location: CLLocation?
    var hasSelectedImage: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        setUpWarningButton()
        updateSendButton()
        hasSelectedImage = false
        setupInspiringLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        location = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpWarningButton() {
        warningButton.layer.cornerRadius = warningButton.frame.height / 2
        warningButton.isHidden = true
    }
    
    private func setUpTextView() {
        textView.delegate = self
        textView.layer.cornerRadius = 4.0
        
        // observa o teclado aparecendo/sumindo
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // oculta o teclado ao tocar na view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupInspiringLabel() {
        previewLabel.text = Inspire.random()
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = view.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
        beginImageSelection()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        guard let senderID = UserManager.sharedManager().uid,
            let text = textView.text else { return }

        // grava a mensagem no banco
        let isNSFW = !warningButton.isHidden
        var message = Message(id: nil, senderID: senderID, hasImage: hasSelectedImage, isNSFW: isNSFW, text: text)
        if location == nil {
            location = GeoManager.sharedManager().location
        }
        message.save(at: location!)
        
        // guarda a mensagem na lista de "mensagens de própria autoria"
        UserManager.sharedManager().save(newMessage: message)
        
        // faz o upload da imagem associada
        if hasSelectedImage, let messageID = message.id {
            let image = backgroundImageView.image!
            FileStore.sharedManager().upload(image: image, forKey: messageID)
        }

        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func warningTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Alerta de conteúdo explícito", message: "A imagem selecionada parece conter conteúdo explícito e, portanto, não será exibida para alguns usuários.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Entendi", style: .cancel, handler: nil))
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSendButton() {
        sendButton.isEnabled = !textView.text.isEmpty
    }
}

extension ComposeMessageViewController: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        previewLabel.text = textView.text
        updateSendButton()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            view.endEditing(true)
            return false
        }
        
        return true
    }
}
