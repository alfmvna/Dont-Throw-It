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

    @IBOutlet weak var newPost: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    var tableView:UITableView!
//
//    var posts = [Post]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView = UITableView(frame: view.bounds, style: .plain)
//
//        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
//
//        view.addSubview(tableView)
//
//        var layoutGuide:UILayoutGuide
//
//        layoutGuide = view.safeAreaLayoutGuide
//
//        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
//        tableView.topAnchor    .constraint(equalTo: layoutGuide.topAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.reloadData()
//        tableView.tableFooterView = UIView()
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
//        cell.set(post: posts[indexPath.row])
//        return cell
//    }
    
    @IBAction func newPost(_ sender: UIButton) {

    }
    
    
}
