//
//  ViewController.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configController()
  }
  
  func configController() {
    let newsNavController = UINavigationController(rootViewController: HomeController())
    let listNavController = UINavigationController(rootViewController: ListController())
    let searchNavController = UINavigationController(rootViewController: SearchController())
    let settingNavController = UINavigationController(rootViewController: AboutController())
    
    newsNavController.tabBarItem.image = UIImage(named: "ic_feed")
    newsNavController.title = "News"
    listNavController.tabBarItem.image = UIImage(named: "ic_option")
    listNavController.title = "Categories"
    searchNavController.tabBarItem.image = UIImage(named: "ic_search")
    searchNavController.title = "Search"
    settingNavController.tabBarItem.image = UIImage(named: "ic_settings")
    settingNavController.title = "About"
    
    viewControllers = [newsNavController, listNavController, searchNavController, settingNavController]
    
    let topBorder = CALayer()
    topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
    topBorder.backgroundColor = UIColor(red: 0.90, green: 0.88, blue: 0.88, alpha: 1.0).cgColor

    tabBar.layer.addSublayer(topBorder)
    tabBar.clipsToBounds = true
  }
  
}

