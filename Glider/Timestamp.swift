//
//  Timestamp.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import Foundation

func dateformatter(date: Double) -> String {
  
  let date1: Date = Date()
  let date2: Date = Date(timeIntervalSince1970: date)
  
  let calender: Calendar = Calendar.current
  let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2, to: date1)
  
  var returnString: String = ""
  
  if components.year! >= 1 {
    returnString = String(describing: components.year!) + " years ago"
  } else if components.month! >= 1 {
    returnString = String(describing: components.month!) + " months ago"
  } else if components.day! >= 1 {
    returnString = String(describing: components.day!) + " days ago"
  } else if components.hour! >= 1 {
    returnString = String(describing: components.hour!) + " hours ago"
  } else if components.minute! >= 1 {
    returnString = String(describing: components.minute!) + " minutes ago"
  } else if components.second! < 60 {
    returnString = "a minute ago"
  }
  
  return returnString
}
