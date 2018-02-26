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
    
    private let storage: StorageReference
    private var cache = (thumbnail: [String: UIImage](), fullSized: [String: UIImage]())
    
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
    
    func thumbnail(forKey key: String, completion: @escaping ((UIImage?, Error?) -> Void)) {
        if let image = cache.thumbnail[key] {
            completion(image, nil)
        }
        
        let path = Constants.storage.messageThumbnailImagePath(forKey: key)
        let ref = storage.child(path)
        ref.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                self?.cache.thumbnail[key] = #imageLiteral(resourceName: "message-thumbnail-example")
                completion(nil, error)
            } else {
                let image = UIImage(data: data!)
                self?.cache.thumbnail[key] = image
                completion(image, nil)
            }
        }
    }
    
    func fullSizedImage(forKey key: String, completion: @escaping ((UIImage?, Error?) -> Void)) {
        if let image = cache.fullSized[key] {
            completion(image, nil)
        }
        
        let path = Constants.storage.messageFullSizedImagePath(forKey: key)
        let ref = storage.child(path)
        ref.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                self?.cache.fullSized[key] = #imageLiteral(resourceName: "message-bg-sample")
                completion(nil, error)
            } else {
                let image = UIImage(data: data!)
                self?.cache.fullSized[key] = image
                completion(image, nil)
            }
        }
    }
    
}
