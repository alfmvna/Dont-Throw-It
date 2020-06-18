//
//  TableViewCell.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 10/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var fotoPost: UIImageView!
    @IBOutlet weak var namaUser: UILabel!
    @IBOutlet weak var alamatUser: UILabel!
    @IBOutlet weak var hpUser: UILabel!
    @IBOutlet weak var keteranganTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func pasang(post:Post) {
        
        ImageServices.getImage(withURL: post.photourl) { (image) in
            self.fotoPost.image = image
        }
        
        namaUser.text = post.author
        alamatUser.text = post.alamat
        hpUser.text = post.nohp
        keteranganTextField.text = post.keterangan
    }
    
}
