//
//  Story.swift
//  Glider
//
//  Created by Yancen Li on 3/5/17.
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
}

extension Story {
    
    static func getStories(completion: @escaping ([Story]) -> Void) {
        
        let url = URL(string: "https://glider.herokuapp.com/news")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            var stories = [Story]()
            
            if let error = error {
                print("Failed to fetch data: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            if let rawStories = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]] {
                rawStories.forEach { rawStroy in
                    stories.append(Story.init(from: rawStroy))
                }
            }
            
            DispatchQueue.main.async {
                completion(stories)
            }
        }.resume()
    }
}
