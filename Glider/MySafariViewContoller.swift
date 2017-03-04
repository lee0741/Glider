//
//  MySafariViewContoller.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import Foundation
import SafariServices

class MySafariViewContoller: SFSafariViewController {
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    UIApplication.shared.statusBarStyle = .default
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(false)
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
}
