//
//  HomeViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class TesterViewController: ViewController{
    
    var databaseRef = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.backgroundColor = UIColor.darkGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(databaseRef)
        
    }
    
    
}

