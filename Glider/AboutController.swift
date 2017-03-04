//
//  SettingController.swift
//  Glider
//
//  Created by Yancen Li on 2/26/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class AboutController: UITableViewController {

  let cellId = "aboutId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configController()
  }
  
  func configController() {
    UIApplication.shared.statusBarStyle = .lightContent
    navigationItem.title = "About"
    tableView = UITableView(frame: tableView.frame, style: .grouped)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.separatorColor = .separatorColor
    tableView.backgroundColor = .bgColor
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 2
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
    cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
    cell.textLabel?.textColor = .mainTextColor
    cell.detailTextLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
    switch indexPath.section {
    case 0:
      cell.textLabel?.text = "Version"
      cell.detailTextLabel?.text = "1.0"
      cell.detailTextLabel?.textColor = .darkGray
    case 1:
      if indexPath.row == 0 {
        cell.textLabel?.text = "Website"
        cell.detailTextLabel?.text = "yancen.org"
        cell.detailTextLabel?.textColor = .mainColor
      } else {
        cell.textLabel?.text = "Twitter"
        cell.detailTextLabel?.text = "@lee0741"
        cell.detailTextLabel?.textColor = .mainColor
      }
    default:
      break
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      switch indexPath.row {
      case 0:
        UIApplication.shared.open(URL(string: "https://yancen.org")!)
      case 1:
        UIApplication.shared.open(URL(string: "https://twitter.com/lee0741")!)
      default:
        break
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
