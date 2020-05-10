//
//  PostingViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 22/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PostingViewController: UIViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.backgroundColor = UIColor.darkGray
        }
    }
    
    @IBOutlet weak var newPost: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
    }
    
    @IBAction func newPost(_ sender: UIButton) {

    }
    
}

extension PostingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: IndexPath.init(row: 0, section: 3))
        
        return cell
    }
    
}
