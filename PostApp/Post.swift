//
//  Post.swift
//  PostApp
//
//  Created by Nick Reichard on 2/21/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import Foundation

struct Post {
    
    private let usernameKey = "username"
    private let timestampKey = "timestamp"
    private let textKey = "text"
    
    let username: String
    let text: String
    let timestamp: TimeInterval
    let identifier: UUID
    
    // This memberwise initializer will only be used locally to generate new model objects.
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, identifier: UUID = UUID()) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
        
        
    }
    
    
    // identifier could be first to match the cast of JSON Serilization / could switch around 
    init?(jsonDictionary: [String: Any], identifier: String) {
        guard let username = jsonDictionary[usernameKey] as? String,
            let timestamp = jsonDictionary[timestampKey] as? Double,
            let text = jsonDictionary[textKey] as? String,
            let identifier = UUID(uuidString: identifier) else { return nil}
        
        self.username = username
        self.text = text
        self.identifier = identifier
        self.timestamp = timestamp
        
    }
    
       // jsonRepresentation that will be used to send Post objects to the API.
        
        var jsonRepresentation: [String:Any] {
            return [usernameKey: username, timestampKey : timestamp, textKey : text]
        }
        
        //This will be used when you set the HTTP Body on the URLRequest, which requires Data?, not a [String: Any]

        
        var jsonData: Data? {
            let data = try? JSONSerialization.data(withJSONObject: jsonRepresentation, options: .prettyPrinted)
            return data
        }
    
    
    
}
