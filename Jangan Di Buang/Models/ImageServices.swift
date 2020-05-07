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
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, url, error in
            var downloadedImage:UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage!)
            }
        }
        
        dataTask.resume()
    }
}
