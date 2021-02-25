//
// Created by Matt Darnall on 2019-04-03.
// Copyright (c) 2019 Salesforce.com. All rights reserved.
//

import Foundation
import PinLayout
import ReactiveSwift

final class RefreshControl: UIRefreshControl {
  var refresh: TriggerSignal!

  override init() {
    super.init()
    refresh = reactive.controlEvents(.valueChanged).ignoreValues()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
