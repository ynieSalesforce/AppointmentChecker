//
//  UIControl.swift
//  Trailhead
//
//  Created by Yuchen Nie on 4/3/20.
//  Copyright © 2020 Salesforce.com. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

extension UIControl {
  func onTap(_ action: (() -> Void)?) {
    reactive.controlEvents(.touchUpInside).take(during: reactive.lifetime)
      .observeValues { _ in
        action?()
      }
  }

  func onValueChanged(_ action: (() -> Void)?) {
    reactive.controlEvents(.valueChanged).take(during: reactive.lifetime)
      .observeValues { _ in
        action?()
      }
  }
}
