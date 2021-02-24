//
//  UITableView+Style.swift
//  Trailhead
//
//  Created by Qingqing Liu on 1/31/20.
//  Copyright © 2020 Salesforce.com. All rights reserved.
//

import UIKit

extension UITableView {
  func style() {

  }

  func hideUnusedRow() {
    tableFooterView = UIView()
  }

  func removeGroupedTableTopSpace() {
    var frame = CGRect.zero
    frame.size.height = .leastNormalMagnitude
    tableHeaderView = UIView(frame: frame)
  }
}
