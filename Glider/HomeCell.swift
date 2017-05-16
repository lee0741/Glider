//
//  HomeCell.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
  
  var story: Story? {
    didSet {
      titleLabel.text = story?.title
      domainLabel.text = story?.domain
      
      if let points = story?.points,
        let user = story?.user {
        infoLabel.text = "\(points) points by \(user) \((story?.time_ago)!)"
      } else {
        infoLabel.text = "\((story?.time_ago)!)"
      }
      
      commentView.numberOfComment = story!.comments_count
      commentView.itemId = story?.id
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont(name: "AvenirNext-Medium", size: 17)
    label.textColor = .mainTextColor
    return label
  }()
  
  private let domainLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont(name: "AvenirNext-Regular", size: 12)
    label.textColor = .lightGray
    return label
  }()
  
  private let infoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont(name: "AvenirNext-Regular", size: 13)
    label.textColor = .darkGray
    return label
  }()
  
  let commentView: CommentIconView = {
    let iconView = CommentIconView()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    return iconView
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(titleLabel)
    addSubview(domainLabel)
    addSubview(infoLabel)
    addSubview(commentView)
    
    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: commentView.leftAnchor, constant: -10).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: domainLabel.topAnchor, constant: -2).isActive = true
    
    domainLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    domainLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
    domainLabel.rightAnchor.constraint(equalTo: commentView.leftAnchor, constant: -10).isActive = true
    domainLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -2).isActive = true
    
    infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    infoLabel.topAnchor.constraint(equalTo: domainLabel.bottomAnchor, constant: 2).isActive = true
    infoLabel.rightAnchor.constraint(equalTo: commentView.leftAnchor, constant: -10).isActive = true
    infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    
    commentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    commentView.heightAnchor.constraint(equalToConstant: 38).isActive = true
    commentView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    commentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
