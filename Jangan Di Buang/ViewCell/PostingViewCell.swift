//
//  PostingViewCell.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 11/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit

class PostingViewCell: TableViewCell {
    
    @IBOutlet weak var fotoPost2: UIImageView!
    @IBOutlet weak var namaUser2: UILabel!
    @IBOutlet weak var alamatUser2: UILabel!
    @IBOutlet weak var hpUser2: UILabel!
    @IBOutlet weak var keteranganTextField2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post:Post) {
        
        ImageServices.getImage(withURL: post.photourl) { (image) in
            self.fotoPost2.image = image
        }
        
        namaUser2.text = post.author
        alamatUser2.text = post.alamat
        hpUser2.text = post.nohp
        keteranganTextField2.text = post.keterangan
    }
    
}
