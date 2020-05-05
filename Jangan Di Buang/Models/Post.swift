//
//  Post.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 05/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import Foundation

class Post{
    var id:String
    var author:String
    var alamat:String
    var nohp:String
    
    init(id:String, author:String, alamat:String, nohp:String) {
        self.id = id
        self.author = author
        self.alamat = alamat
        self.nohp = nohp
    }
}
