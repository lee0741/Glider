//
//  Comment.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import Foundation

struct Comment {
  let id: Int
  let level: Int
  let time_ago: String
  let content: String
  var user: String?
  
  init(from json: [String: Any]) {
    self.id = json["id"] as! Int
    self.level = json["level"] as! Int
    self.time_ago = json["time_ago"] as! String
    self.content = json["content"] as! String
    self.user = json["user"] as? String
  }
}

extension Comment {
  static func extractComments(from rawComment: [String: Any]) -> [Comment] {
    var kids = [Comment]()
    
    if let comments = rawComment["comments"] as? [[String: Any]] {
      comments.forEach { (comment) in
        kids.append(contentsOf: extractComments(from: comment))
      }
    }
    
    let kid = Comment(from: rawComment)
    if kid.content != "[deleted]" {
      kids.insert(Comment(from: rawComment), at: 0)
    }
    return kids
  }
  
  static func getComments(from itemId: Int, completion: @escaping ([Comment], Story?) -> Void) {
    
    URLSession.shared.dataTask(with: URL(string: "https://glider.herokuapp.com/item/\(itemId)")!) { (data, response, error) in
      var comments = [Comment]()
      var story: Story?
      
      if let error = error {
        print("Failed to fetch data: \(error)")
        return
      }
      
      guard let data = data else { return }
      
      if let rawData = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
        story = Story(from: rawData)
        let rawComments = rawData["comments"] as! [[String: Any]]
        rawComments.forEach { rawComment in
          comments.append(contentsOf: extractComments(from: rawComment))
        }
      }
      
      DispatchQueue.main.async {
        completion(comments, story)
      }
      
    }.resume()
    
  }
}
