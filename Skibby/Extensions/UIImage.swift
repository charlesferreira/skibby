//
//  UIImage.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

extension UIImage {
    
    var isLandscape: Bool {
        return size.width > size.height
    }
    
    func resized(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage? {
        let scale = isLandscape
            ? (maxWidth / size.width)
            : (maxHeight / size.height)
        
        let width = size.width * scale
        let height = size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func stretched(width: CGFloat, height: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let strechedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return strechedImage
    }
    
}
