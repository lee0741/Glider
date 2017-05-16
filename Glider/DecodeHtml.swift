//
//  DecodeHtml.swift
//  Glider
//
//  Created by Yancen Li on 2/24/17.
//  Copyright © 2017 Yancen Li. All rights reserved.
//

import UIKit

extension String {
  func attributedString() -> NSAttributedString? {
    guard let data = self.data(using: .utf8) else {
      return nil
    }
    let result = try? NSMutableAttributedString(data: data,
                                                options: [
                                                  NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                  NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
                                                ],
                                                documentAttributes: nil)
    result?.addAttributes([NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 16.0)!],
                          range: NSMakeRange(0, (result?.string.characters.count)!))
    return result
  }
}
