//
//  UIImageView-Extension.swift
//  Asurion-iOS
//
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    /// DOwnload and cache Image
    /// - Parameter url: target image url
    /// - Parameter imageMode: image fit mode to imageview
    /// - Parameter completion: handle image after receiving
    func downloadImageFrom(url: URL, imageMode : UIView.ContentMode? = .scaleAspectFit,completion: @escaping ()->()) {
            contentMode = imageMode ?? .scaleAspectFit
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
                self.image = cachedImage
            } else {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        if let imageToCache = UIImage(data: data) {
                            imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                            self.image = imageToCache
                            completion()
                        }
                    }
                }.resume()
            }
        }
}
