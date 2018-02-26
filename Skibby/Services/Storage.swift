//
//  Storage.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase

class FileStore {
    
    static func sharedManager() -> FileStore {
        struct Static { static let instance = FileStore() }
        return Static.instance
    }
    
    let storage: StorageReference
    
    private init() {
        storage = Storage.storage().reference()
    }
    
    func upload(image: UIImage, forKey key: String) {
        uploadFullSizedImage(image: image, forKey: key)
        uploadThumbnailImage(image: image, forKey: key)
    }
    
    func uploadFullSizedImage(image: UIImage, forKey key: String) {
        let size = Constants.storage.maxImageSize
        let path = Constants.storage.messageFullSizedImagePath(forKey: key)
        upload(image: image, forKey: key, size: size, storagePath: path)
    }
    
    func uploadThumbnailImage(image: UIImage, forKey key: String) {
        let size = Constants.storage.thumbnailSize
        let path = Constants.storage.messageThumbnailImagePath(forKey: key)
        upload(image: image, forKey: key, size: size, storagePath: path)
    }
    
    func upload(image: UIImage, forKey key: String, size: CGSize, storagePath: String) {
        guard let resizedImage = image.resized(maxWidth: size.width, maxHeight: size.height) else { return }
        
        if let data = UIImageJPEGRepresentation(resizedImage, 0.9) {
            let ref = storage.child(storagePath)
            ref.putData(data)
        }
        
    }
}
