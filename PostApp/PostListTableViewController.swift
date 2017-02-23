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
    // MARK: - Action
    
    @IBAction func plussButtonTapped(_ sender: Any) {
        
        presentNewPostAlert()
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
    
    // MARK: - Alert
    
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "ADD NEW POST", message: "Add new post hommie", preferredStyle: .alert)
        let dissMissAction = UIAlertAction(title: "DISSMISS", style: .cancel, handler: nil)
        
        var usernameTextField: UITextField?
        alertController.addTextField { (texfield) in
            usernameTextField = texfield
        }
        
        var messageTextField: UITextField?
        alertController.addTextField { (textField) in
            messageTextField = textField
        }
        
        let addPostAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let userNameText = usernameTextField?.text, usernameTextField?.text != "",
                let postMessage = messageTextField?.text, messageTextField?.text != "" else { self.presentErrorAlert(); return }
            self.postController.addNewPostWith(username: userNameText, text: postMessage, completion: { (true) in
                self.tableView.reloadData()
            })
            
            
            self.tableView.reloadData()
            
        }
        alertController.addAction(addPostAction)
        alertController.addAction(dissMissAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        // MARK: - Error Alert
        
        
        
    }
    
    func presentErrorAlert() {
        let errorAlertController = UIAlertController(title: "Enter in User Name and message", message: "Fill it out", preferredStyle: .alert)
        let dissmissAction = UIAlertAction(title: "Dissmiss", style: .default) { (_) in
            self.presentNewPostAlert()
        }
        
        errorAlertController.addAction(dissmissAction)
        self.present(errorAlertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Delegate
    
    func postsWereUpdatedTo(posts: [Post], on: PostController) {
        tableView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
