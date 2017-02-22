//
//  PostController.swift
//  PostApp
//
//  Created by Nick Reichard on 2/21/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = URL(string: "https://devmtn-post.firebaseio.com/posts/")
    
    static let getterEndpoint = baseURL?.appendingPathExtension("json")
    
    // MARK: - Properties 
    
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsWereUpdatedTo(posts: posts, on: self)
        }
    }
    
    init(){
      // fetched? K
    }
    
    func fetchPosts(completion: @escaping ([Post]) -> Void ) {
        
        guard let url = PostController.getterEndpoint else { return }
        
        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: nil, body: nil) { (data, error) in
            
            if error != nil {
                print("\(error)")
                completion([])
                return
            }
            guard let data = data else { completion([]); return }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:[String:Any]] else { completion([]); return }
            
            let postArray = jsonDictionary.flatMap({ Post(jsonDictionary: $0.value , identifier: $0.key)})
            let sortedArray = postArray.sorted(by: { $0.0.timestamp > $0.1.timestamp } )
            
            
            
            //Grand Central Dispatch to force the completion closure to run on the main thread.
            
            DispatchQueue.main.async {
                self.posts = sortedArray
                completion(sortedArray)
                
            }
            
        }
    }
}


protocol PostControllerDelegate: class {
    func postsWereUpdatedTo(posts: [Post], on: PostController)
}





