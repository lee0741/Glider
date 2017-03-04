//
//  HomeController.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class HomeController: UITableViewController, UISearchResultsUpdating {
  
  let cellId = "homeId"
  let defaults = UserDefaults.standard
  var stories = [Story]()
  var storyType = StoryType.news
  var query = ""
  var pagination = 1
  var updating = false
  var searchController: UISearchController!
  var searchResults = [Story]()
  var savedSearches = [String]()
  var searchableItems = [CSSearchableItem]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configController()
    
    Story.getStories(type: storyType, query: query, pagination: 1) { stories in
      self.stories = stories
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      self.tableView.reloadData()
      self.setupSearchableContent(stories)
    }
  }
  
  func configController() {
    if let savedSearch = defaults.object(forKey: "SavedQuery") {
      savedSearches = savedSearch as! [String]
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    UIApplication.shared.statusBarStyle = .lightContent
    
    if storyType == .search {
      navigationItem.title = query
      if savedSearches.contains(query) == false {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
        navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
      }
    } else {
      navigationItem.title = storyType.rawValue
    }
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    tableView.register(HomeCell.self, forCellReuseIdentifier: cellId)
    tableView.estimatedRowHeight = 80.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorColor = .separatorColor
    
    searchController = UISearchController(searchResultsController: nil)
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.tintColor = .mainColor
    searchController.searchBar.searchBarStyle = .minimal
    definesPresentationContext = true
    searchController.loadViewIfNeeded()
    
    refreshControl = UIRefreshControl()
    refreshControl?.tintColor = .mainColor
    refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
    if traitCollection.forceTouchCapability == .available {
      registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: view)
    }
  }
  
  func saveAction() {
    navigationItem.setRightBarButton(UIBarButtonItem(), animated: true)
    savedSearches.append(query)
    defaults.set(savedSearches, forKey: "SavedQuery")
    defaults.synchronize()
  }
  
  // MARK: - Spotlight Search
  
  func setupSearchableContent(_ newStories: [Story]) {
    
    newStories.forEach { story in
      let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
      
      searchableItemAttributeSet.title = story.title
      searchableItemAttributeSet.contentDescription = story.domain
      searchableItemAttributeSet.keywords = [story.title]
      
      let searchableItem = CSSearchableItem(uniqueIdentifier: "org.yancen.glider.\(story.id)", domainIdentifier: "story", attributeSet: searchableItemAttributeSet)
      searchableItems.append(searchableItem)
    }
    
    CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
      if error != nil {
        print(error?.localizedDescription ?? "Fail to index")
      }
    }
  }
  
  override func restoreUserActivityState(_ activity: NSUserActivity) {
    if activity.activityType == CSSearchableItemActionType {
      if let userInfo = activity.userInfo {
        let selectedStory = userInfo[CSSearchableItemActivityIdentifier] as! String
        let commentController = CommentController()
        commentController.itemId = Int(selectedStory.components(separatedBy: ".").last!)!
        navigationController?.pushViewController(commentController, animated: true)
      }
    }
  }
  
  // MARK: - Pull to Refresh
  
  func handleRefresh(_ refreshControl: UIRefreshControl) {
    pagination = 1
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    Story.getStories(type: storyType, query: query, pagination: 1) { stories in
      self.stories = stories
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      OperationQueue.main.addOperation {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        self.searchableItems = [CSSearchableItem]()
        self.setupSearchableContent(stories)
      }
    }
  }
  
  // MARK: - Search Logic
  
  func filterContent(for searchText: String) {
    searchResults = stories.filter { (story) -> Bool in
      let isMatch = story.title.localizedCaseInsensitiveContains(searchText)
      return isMatch
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      filterContent(for: searchText)
      tableView.reloadData()
    }
  }
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchController.searchBar.endEditing(true)
  }
  
  // MARK: - Table View Data Source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchController.isActive ? searchResults.count : stories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeCell
    let story = searchController.isActive ? searchResults[indexPath.row] : stories[indexPath.row]
    cell.story = story
    cell.commentView.addTarget(self, action: #selector(pushToCommentView(_:)), for: .touchUpInside)
    cell.layoutIfNeeded()
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if storyType != .search && stories.count - indexPath.row < 10 && !updating && pagination < 18 {
      updating = true
      pagination += 1
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      Story.getStories(type: storyType, query: query, pagination: pagination) { stories in
        self.stories += stories
        self.updating = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.tableView.reloadData()
        self.setupSearchableContent(stories)
      }
    }
  }
  
  // MARK: - Table View Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let story = searchController.isActive ? searchResults[indexPath.row] : stories[indexPath.row]
    
    if story.url.hasPrefix("https://news.ycombinator.com/item?id=") {
      let commentController = CommentController()
      commentController.itemId = story.id
      navigationController?.pushViewController(commentController, animated: true)
    } else {
      let safariController = MySafariViewContoller(url: URL(string: story.url)!)
      present(safariController, animated: true, completion: nil)
    }
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return searchController.isActive ? false : true
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let story = self.stories[indexPath.row]
    
    let shareAction = UITableViewRowAction(style: .default, title: "Share", handler:
      { (action, indexPath) -> Void in
        let defaultText = story.title + " " + story.url
        let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    })
    
    shareAction.backgroundColor = .mainColor
    
    return [shareAction]
  }
  
  func pushToCommentView(_ sender: CommentIconView) {
    guard sender.numberOfComment != 0 else { return }
    let commentController = CommentController()
    commentController.itemId = sender.itemId
    navigationController?.pushViewController(commentController, animated: true)
  }
  
}

// MARK: - 3D Touch

extension HomeController: UIViewControllerPreviewingDelegate {
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let indexPath = tableView.indexPathForRow(at: location),
      let cell = tableView.cellForRow(at: indexPath),
      let url = URL(string: stories[indexPath.row].url) else {
        return nil
    }
    
    let safariController = MySafariViewContoller(url: url)
    previewingContext.sourceRect = cell.frame
    
    return safariController
  }
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    present(viewControllerToCommit, animated: true, completion: nil)
  }
}
