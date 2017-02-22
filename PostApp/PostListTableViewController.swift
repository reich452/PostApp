//
//  PostListTableViewController.swift
//  PostApp
//
//  Created by Nick Reichard on 2/21/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {
    
    let postController = PostController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        postController.delegate = self
       
    
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = postController.posts[indexPath.row]
        let postDate = Date(timeIntervalSince1970: post.timestamp)
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = ("\(indexPath.row) \(post.username) \(postDate) ")
        
        return cell
    }
    
    
    @IBAction func refreshControllerPulled(_ sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
        
    }
    
    
   
    
    // MARK: - Delegate 
    
    func postsWereUpdatedTo(posts: [Post], on: PostController) {
        tableView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
   
}
