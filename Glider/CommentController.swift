//
//  CommentController.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class CommentController: UITableViewController, UIViewControllerPreviewingDelegate {
  
  let defaults = UserDefaults.standard
  let infoCellId = "storyInfoCell"
  let commentCellId = "commentCell"
  var comments = [Comment]()
  var story: Story?
  var itemId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUi()
    
    Comment.getComments(from: itemId!) { comments, story in
      self.story = story
      self.comments = comments
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Config UI
  
  func configUi() {
    title = "Comment"
    
    tableView.register(HomeCell.self, forCellReuseIdentifier: infoCellId)
    tableView.register(CommentCell.self, forCellReuseIdentifier: commentCellId)
    tableView.separatorColor = .separatorColor
    
    let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(CommentController.shareAction))
    navigationItem.setRightBarButton(shareBarButtonItem, animated: true)
    
    UIApplication.shared.statusBarStyle = .lightContent
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    if traitCollection.forceTouchCapability == .available {
      registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: view)
    }
  }
  
  // MARK: - Share Action
  
  func shareAction() {
    let defaultText = "Discuss on HN: \(story!.title) https://news.ycombinator.com/item?id=\(story!.id)"
    let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
    self.present(activityController, animated: true, completion: nil)
  }
  
  // MARK: - Table View
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return story == nil ?  comments.count : comments.count+1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard story != nil else {
      return tableView.dequeueReusableCell(withIdentifier: commentCellId) as! CommentCell
    }
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: infoCellId) as! HomeCell
      cell.story = story
      cell.layoutIfNeeded()
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! CommentCell
      cell.comment = comments[indexPath.row-1]
      cell.layoutIfNeeded()
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0,
      let url = URL(string: story!.url) {
      let safariController = MySafariViewContoller(url: url)
      present(safariController, animated: true, completion: nil)
    }
  }
  
  // MARK: - 3D Touch
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let indexPath = tableView.indexPathForRow(at: location) else {
      return nil
    }
    
    if indexPath.row == 0,
      let cell = tableView.cellForRow(at: indexPath),
      let url = URL(string: story!.url) {
      let safariController = MySafariViewContoller(url: url)
      previewingContext.sourceRect = cell.frame
      return safariController
    } else {
      return nil
    }
  }
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    present(viewControllerToCommit, animated: true, completion: nil)
  }
}
