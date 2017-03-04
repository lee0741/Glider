//
//  CommentIconView.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class CommentIconView: UIButton {
  private var _comments: Int = 0
  
  var itemId: Int?
  
  var numberOfComment: Int {
    set(newNumberOfComment) {
      _comments = newNumberOfComment
      setNeedsDisplay()
    }
    get {
      return _comments
    }
  }
  
  override func draw(_ rect: CGRect) {
    CommentIconDraw.drawCommentIcon(frame: bounds, commentsCount: "\(numberOfComment)")
  }
}
