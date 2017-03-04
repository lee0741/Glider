//
//  CommentCell.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
  
  var comment: Comment? {
    didSet {
      commentView.attributedText = comment?.content.attributedString()
      timeLabel.text = comment?.time_ago
      indentationLevel = (comment?.level)!
      if let user = comment?.user {
        nameLabel.text = user
        avatarView.userName = String(user.characters.prefix(1)).uppercased()
      }
    }
  }
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "AvenirNext-Medium", size: 15)
    label.textColor = .mainTextColor
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "AvenirNext-Regular", size: 13)
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let commentView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont(name: "AvenirNext-Regular", size: 15)
    textView.textColor = .mainTextColor
    textView.isEditable = false
    textView.isScrollEnabled = false
    textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.00, green: 0.40, blue: 0.00, alpha: 1.0)]
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  
  let avatarView: AvatarView = {
    let avatarView = AvatarView()
    avatarView.backgroundColor = .white
    avatarView.translatesAutoresizingMaskIntoConstraints = false
    return avatarView
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    indentationLevel = 0
    indentationWidth = 10
    
    addSubview(nameLabel)
    addSubview(timeLabel)
    addSubview(commentView)
    addSubview(avatarView)
    
    avatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    avatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    avatarView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    avatarView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    
    nameLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 10).isActive = true
    nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    nameLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -1).isActive = true
    
    timeLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 10).isActive = true
    timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1).isActive = true
    timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    timeLabel.bottomAnchor.constraint(equalTo: commentView.topAnchor, constant: -5).isActive = true
    
    commentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    commentView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
    commentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    let bottomConstraint = commentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
    bottomConstraint.priority = 999
    bottomConstraint.isActive = true
    
    shouldIndentWhileEditing = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var frame: CGRect {
    didSet {
      var newFrame = frame
      let inset = CGFloat(indentationLevel) * indentationWidth
      newFrame.origin.x += inset
      newFrame.size.width -= inset
      super.frame = newFrame
    }
  }
  
}
