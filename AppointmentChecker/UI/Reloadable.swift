//
//  Retryable.swift
//  Trailhead
//
//  Created by Qingqing Liu on 3/12/19.
//  Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation

// Reloadable ViewController
protocol Reloadable {
  func reload()
  func isDataLoaded() -> Bool
}
