//
//  AppDelegate.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainController()
        
        UINavigationBar.appearance().barTintColor = .mainColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UITabBar.appearance().tintColor = .mainColor
        
        let categoryItem = UIApplicationShortcutItem(type: "org.yancen.Glider.category", localizedTitle: "Categories", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "ic_option"), userInfo: nil)
        let searchItem = UIApplicationShortcutItem(type: "org.yancen.Glider.search", localizedTitle: "Search", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .search), userInfo: nil)
        UIApplication.shared.shortcutItems = [categoryItem, searchItem]
        
        if let item = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            switch item.type {
            case "org.yancen.Glider.category":
                launchListController()
            case "org.yancen.Glider.search":
                launchSearchController()
            default:
                break
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    // MARK: - Spotlight Search
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        (window?.rootViewController as! MainController).selectedIndex = 0
        let viewController = (window?.rootViewController as! MainController).childViewControllers[0].childViewControllers[0] as! HomeController
        viewController.restoreUserActivityState(userActivity)
        
        return true
    }
    
    // MARK: - URL Scheme
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let query = url.host else { return true }
        
        let commentController = CommentController()
        commentController.itemId = Int(query)
        (window?.rootViewController as! MainController).selectedIndex = 0
        (window?.rootViewController as! MainController).childViewControllers[0].childViewControllers[0].navigationController?.pushViewController(commentController, animated: true)
        return true
    }
    
    // MARK: - 3D Touch
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case "org.yancen.Glider.category":
            launchListController()
        case "org.yancen.Glider.search":
            launchSearchController()
        default:
            return
        }
    }
    
    func launchListController() {
        (window?.rootViewController as! MainController).selectedIndex = 1
    }
    
    func launchSearchController() {
        (window?.rootViewController as! MainController).selectedIndex = 2
    }
}

