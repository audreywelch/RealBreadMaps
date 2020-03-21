//
//  UIImageView + Load.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/20.
//  Copyright © 2020 Audrey Welch. All rights reserved.
//

import UIKit

// Extension of UIImageView to load URLs, convert to data, then convert to a UIImage in a background queue, but load it to the image view on the main thread

extension UIImageView {
    
    func loadImage(at urlString: String) {
        UIImageLoader.loader.load(urlString, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
