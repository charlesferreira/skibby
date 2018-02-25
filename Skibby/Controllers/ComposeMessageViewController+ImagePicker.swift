//
//  ComposeMessageViewController+ImagePicker.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

extension ComposeMessageViewController {

    func filterExplicitContent(forImage image: CGImage) {
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image) {
            guard let prediction = try? nsfwModel.prediction(data: pixelBuffer) else { return }
            print("--------")
            print(prediction.classLabel)
            print(prediction.prob)
            print("--------")
            warningButton.isHidden = prediction.classLabel == "SFW"
        }
    }
}

extension ComposeMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func beginImageSelection() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (_) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        })
        cameraAction.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        actionSheet.addAction(cameraAction)
        
        actionSheet.addAction(UIAlertAction(title: "Galeria de imagens", style: .default, handler: { (_) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        navigationController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImageView.image = image
            if let cgImage = image.stretched(width: 224, height: 224)?.cgImage {
                filterExplicitContent(forImage: cgImage)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
