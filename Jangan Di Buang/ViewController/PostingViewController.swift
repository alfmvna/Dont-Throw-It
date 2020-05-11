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
    
    var posts = [Post]()
    var databaseRef = Database.database().reference()
    var refreshControl: UIRefreshControl!
    
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
        tableView.register(UINib(nibName: "PostingViewCell", bundle: nil), forCellReuseIdentifier: "PostingViewCell")
        
        loadPost()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        
        tableView.reloadData()
        self.refreshControl.endRefreshing()
        
    }
    
    @IBAction func newPost(_ sender: UIButton) {

    }
    
    func loadPost(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postRef = databaseRef.child("posts").child(uid)
        
        postRef.observe(.value) { (snapshot) in
            if snapshot.exists() {
                for userSnapshot in snapshot.children {
                    guard let userSnap = userSnapshot as? DataSnapshot else {return}
                    guard let dict = userSnap.value as? [String:Any] else {return}
                    guard let alamat = dict["alamat"] as? String else {return}
                    guard let keterangan = dict["keterangan"] as? String else {return}
                    guard let photourl = dict["photoURL"] as? String else {return}
                    guard let url = URL(string: photourl) else {return}
                    guard let author = dict["nama"] as? String else {return}
                    guard let nohp = dict["nohp"] as? String else {return}
                    guard let timestamp = dict["timestamp"] as? Double else {return}
                    
                    let post = Post(keterangan: keterangan, photourl: url, author: author, alamat: alamat, nohp: nohp, timestamp: timestamp)
                    self.posts.append(post)
                }
            }
        }
    }
    
}

extension PostingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostingViewCell", for: indexPath) as! PostingViewCell
        cell.set(post: posts[indexPath.row])
        
        
        return cell
    }
    
}
