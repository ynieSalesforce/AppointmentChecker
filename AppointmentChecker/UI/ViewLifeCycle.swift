//
// Created by Matt Darnall on 2019-03-12.
// Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation
import ReactiveSwift

internal struct ViewLifeCycle {
  let isVisible: Property<Bool>

  init() {
    isVisible = Property(initial: false, then: Signal.merge(
      viewDidAppearProperty.signal.map(const(true)),
      viewDidDisappearProperty.signal.map(const(false))
    ).skipRepeats())
  }

  let viewDidLoadProperty = MutableProperty(())
  public func viewDidLoad() {
    viewDidLoadProperty.value = ()
  }

  let viewDidAppearProperty = MutableProperty(())
  public func viewDidAppear() {
    viewDidAppearProperty.value = ()
  }

  let viewDidDisappearProperty = MutableProperty(())
  public func viewDidDisappear() {
    viewDidDisappearProperty.value = ()
  }
}
