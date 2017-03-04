//
//  AvatarView.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class AvatarView: UIView {
  private var _name = ""
  
  var userName: String {
    set(newUserName) {
      _name = newUserName
      setNeedsDisplay()
    }
    get {
      return _name
    }
  }
  
  override func draw(_ rect: CGRect) {
    AvatarDraw.drawAvatar(frame: bounds, userName: userName)
  }
}

