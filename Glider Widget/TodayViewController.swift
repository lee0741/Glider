//
//  TodayViewController.swift
//  Glider Widget
//
//  Created by Yancen Li on 3/3/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit
import NotificationCenter

@objc(TodayViewController)

class TodayViewController: UITableViewController, NCWidgetProviding {
  
    let cellId = "widgetCell"
    var stories = [Story]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 55
        Story.getStories() { stories in
            self.stories = stories
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let story = stories[indexPath.row]
        cell.textLabel?.text = story.title
        cell.detailTextLabel?.text = story.domain
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.detailTextLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        cell.detailTextLabel?.textColor = .gray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemId = stories[indexPath.row].id
        self.extensionContext?.open(URL(string: "glider://\(itemId)")!)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        Story.getStories() { stories in
            self.stories = stories
            self.tableView.reloadData()
            completionHandler(NCUpdateResult.newData)
        }
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else {
            self.preferredContentSize = CGSize(width: 0, height: 550)
        }
    }
    
}
