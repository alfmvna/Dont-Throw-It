//
//  Post.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 05/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import Foundation

class Post{
    var keterangan:String
    var photourl:URL
    var author:String
    var alamat:String
    var nohp:String
    var timestamp:Double
    
    init(keterangan:String, photourl:URL, author:String, alamat:String, nohp:String, timestamp:Double) {
        self.keterangan = keterangan
        self.photourl = photourl
        self.author = author
        self.alamat = alamat
        self.nohp = nohp
        self.timestamp = timestamp
    }
    
}
