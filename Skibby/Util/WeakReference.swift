//
//  WeakReference.swift
//  Skibby
//
//  Created by Charles Ferreira on 24/02/2018.
//  Credits: https://marcosantadev.com/swift-arrays-holding-elements-weak-references/
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

class WeakReference<T> where T: AnyObject {
    
    private (set) weak var value: T?
    
    init(value: T?) {
        self.value = value
    }
}
