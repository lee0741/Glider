//
//  SearchController.swift
//  Glider
//
//  Created by Yancen Li on 2/26/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class SearchController: UITableViewController {

  let cellId = "searchId"
  let defaults = UserDefaults.standard
  var editBarButtonItem: UIBarButtonItem?
  var savedSearches = [String]()
  var searchController: UISearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configController()
  }
  
  func configController() {
    if let savedSearch = defaults.object(forKey: "SavedQuery") {
      savedSearches = savedSearch as! [String]
    }
    
    UIApplication.shared.statusBarStyle = .lightContent
    navigationItem.title = "Search"
    
    if savedSearches.count != 0 {
      editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAction))
      navigationItem.setRightBarButton(editBarButtonItem, animated: true)
    }
    
    tableView = UITableView(frame: tableView.frame, style: .grouped)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.separatorColor = .separatorColor
    tableView.backgroundColor = .bgColor
    
    searchController = UISearchController(searchResultsController: nil)
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchBar.delegate = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.tintColor = .mainColor
    searchController.searchBar.searchBarStyle = .minimal
    definesPresentationContext = true
    searchController.loadViewIfNeeded()
    
    NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    searchController.searchBar.resignFirstResponder()
  }
  
  func defaultsChanged() {
    if let savedSearch = defaults.object(forKey: "SavedQuery") {
      savedSearches = savedSearch as! [String]
    }
    
    if savedSearches.count == 0 {
      navigationItem.setRightBarButton(UIBarButtonItem(), animated: true)
      editBarButtonItem = nil
    } else {
      if editBarButtonItem == nil {
        editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAction))
        navigationItem.setRightBarButton(editBarButtonItem, animated: true)
      }
    }
    
    tableView.reloadData()
  }
  
  func editAction() {
    if tableView.isEditing {
      navigationItem.rightBarButtonItem?.title = "Edit"
      tableView.setEditing(false, animated: true)
    } else {
      navigationItem.rightBarButtonItem?.title = "Done"
      tableView.setEditing(true, animated: true)
    }
  }
  
  // MARK: - Table View Data Source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Saved Searches"
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if savedSearches.count == 0 {
      return 1
    } else {
      return savedSearches.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    if savedSearches.count == 0 {
      cell.textLabel?.text = "No saved searches found."
      cell.textLabel?.textColor = .lightGray
      cell.selectionStyle = .none
      cell.accessoryType = .none
    } else {
      cell.textLabel?.text = savedSearches[indexPath.row]
      cell.textLabel?.textColor = .mainTextColor
      cell.accessoryType = .disclosureIndicator
    }
    
    cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if savedSearches.count != 0 {
      let homeController = HomeController()
      homeController.query = savedSearches[indexPath.row]
      homeController.storyType = .search
      navigationController?.pushViewController(homeController, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      savedSearches.remove(at: indexPath.row)
      if savedSearches.count == 0 {
        tableView.reloadData()
        tableView.setEditing(false, animated: true)
      } else {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
      defaults.set(savedSearches, forKey: "SavedQuery")
      defaults.synchronize()
    }
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    if tableView.isEditing {
      return .delete
    } else {
      return .none
    }
  }
}

// MARK: - Search Delegate

extension SearchController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let homeController = HomeController()
    guard let query = searchBar.text else {
      return
    }
    homeController.query = query
    homeController.storyType = .search
    navigationController?.pushViewController(homeController, animated: true)
  }
}
