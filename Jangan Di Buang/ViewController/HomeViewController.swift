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

class HomeViewController: ViewController{
    
    var posts = [Post]()
    var databaseRef = Database.database().reference()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.backgroundColor = UIColor.darkGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        loadPost()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        
        tableView.reloadData()
        self.refreshControl.endRefreshing()

    }
    
    func test(){
        
    }
    
    func loadPost(){
        let postRef = databaseRef.child("posts")
        
        postRef.observe(.value) { (snapshot) in
            if snapshot.exists() {
                for userSnapshot in snapshot.children {
                    let userSnap = userSnapshot as! DataSnapshot
                    for childSnapshot in userSnap.children {
                        let childSnap = childSnapshot as! DataSnapshot
                        let dict = childSnap.value as! [String:Any]
                        
                        let alamat = dict["alamat"] as! String
                        let keterangan = dict["keterangan"] as! String
                        let photourl = dict["photoURL"] as! String
                        let url = URL(string: photourl)
                        let author = dict["nama"] as! String
                        let nohp = dict["nohp"] as! String
                        let timestamp = dict["timestamp"] as! Double
                        
                        let post = Post(keterangan: keterangan, photourl: url!, author: author, alamat: alamat, nohp: nohp, timestamp: timestamp)
                        self.posts.append(post)
                    }
                }
            }
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.pasang(post: posts[indexPath.row])
        
        return cell
    }
    
}
