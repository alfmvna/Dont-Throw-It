//
//  PostTableViewCell.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 05/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var alamatLabel: UILabel!
    
    @IBOutlet weak var nohpLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var barangImage: UIImageView!
    
    @IBOutlet weak var profilImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilImage.layer.cornerRadius = profilImage.bounds.height / 2
        profilImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post: Post) {
        usernameLabel.text = post.author
        alamatLabel.text = post.alamat
        nohpLabel.text = post.nohp
    }
    
}
