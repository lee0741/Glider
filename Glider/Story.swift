//
//  Story.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import Foundation

enum StoryType: String {
  case news = "Hacker News"
  case best = "Best"
  case newest = "Newest"
  case ask = "Ask HN"
  case show = "Show HN"
  case jobs = "Jobs"
  case noobstories = "Noob Stories"
  case search
}

struct Story {
  let id: Int
  let title: String
  let time_ago: String
  let comments_count: Int
  let url: String
  let domain: String
  var points: Int?
  var user: String?
  
  init(from json: [String: Any]) {
    // for noob and best type
    if let id = json["id"] as? Int {
      self.id = id
    } else {
      self.id = Int(json["id"] as! String)!
    }
    
    self.title = json["title"] as! String
    self.time_ago = json["time_ago"] as! String
    self.comments_count = json["comments_count"] as! Int
    
    // for jobs type
    self.points = json["points"] as? Int
    self.user = json["user"] as? String
    
    let url = json["url"] as! String
    if url.hasPrefix("item?id=") {
      self.url = "https://news.ycombinator.com/\(url)"
      self.domain = "news.ycombinator.com"
    } else {
      self.url = url
      self.domain = url.components(separatedBy: "/")[2]
    }
  }
  
  init(searchResponse: [String: Any]) {
    self.id = Int(searchResponse["objectID"] as! String)!
    self.title = searchResponse["title"] as! String
    
    self.points = searchResponse["points"] as? Int
    self.user = searchResponse["author"] as? String
    
    let timestamp = searchResponse["created_at_i"] as! Double
    self.time_ago = dateformatter(date: timestamp)
    
    if let url = searchResponse["url"] as? String {
      self.url = url
      self.domain = url.components(separatedBy: "/")[2]
    } else {
      self.url = "https://news.ycombinator.com/item/\(self.id))"
      self.domain = "news.ycombinator.com"
    }
    
    if let comments_count = searchResponse["num_comments"] as? Int {
      self.comments_count = comments_count
    } else {
      self.comments_count = 0
    }
  }
}

extension Story {
  
  static func getStories(type: StoryType, query: String, pagination: Int, completion: @escaping ([Story]) -> Void) {
    
    var url: URL!
    
    if type == .search {
      url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story&query=\(query)&hitsPerPage=100")!
    } else {
      url = URL(string: "https://glider.herokuapp.com/\(type)?page=\(pagination)")!
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      var stories = [Story]()
      
      if let error = error {
        print("Failed to fetch data: \(error)")
        return
      }
      
      guard let data = data else { return }
      
      if type == .search {
        if let rawData = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any],
          let rawStories = rawData["hits"] as? [[String: Any]] {
          rawStories.forEach { rawStroy in
            stories.append(Story.init(searchResponse: rawStroy))
          }
        }
      } else {
        if let rawStories = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]] {
          rawStories.forEach { rawStroy in
            stories.append(Story.init(from: rawStroy))
          }
        }
      }
      
      DispatchQueue.main.async {
        completion(stories)
      }
    }.resume()
  }
}
