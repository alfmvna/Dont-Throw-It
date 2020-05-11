//
//  ImageServices.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 06/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import Foundation
import UIKit

class ImageServices {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, responseurl, error in
            var downloadedImage:UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage!)
            }
        }
        
        dataTask.resume()
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
