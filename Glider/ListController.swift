//
//  ListController.swift
//  Glider
//
//  Created by Yancen Li on 2/26/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class ListController: UITableViewController {
  
  let cellId = "categoryId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configController()
  }
  
  func configController() {
    UIApplication.shared.statusBarStyle = .lightContent
    navigationItem.title = "Categories"
    tableView = UITableView(frame: tableView.frame, style: .grouped)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.separatorColor = .separatorColor
    tableView.backgroundColor = .bgColor
  }
  
  // MARK: - Table View Data Source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
    cell.textLabel?.textColor = .mainTextColor
    cell.accessoryType = .disclosureIndicator
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = "Best"
    case 1:
      cell.textLabel?.text = "Newest"
    case 2:
      cell.textLabel?.text = "Ask HN"
    case 3:
      cell.textLabel?.text = "Show HN"
    case 4:
      cell.textLabel?.text = "Jobs"
    case 5:
      cell.textLabel?.text = "Noob Stories"
    default:
      break
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let homeController = HomeController()
    switch indexPath.row {
    case 0:
      homeController.storyType = .best
    case 1:
      homeController.storyType = .newest
    case 2:
      homeController.storyType = .ask
    case 3:
      homeController.storyType = .show
    case 4:
      homeController.storyType = .jobs
    case 5:
      homeController.storyType = .noobstories
    default:
      break
    }
    navigationController?.pushViewController(homeController, animated: true)
  }
}

