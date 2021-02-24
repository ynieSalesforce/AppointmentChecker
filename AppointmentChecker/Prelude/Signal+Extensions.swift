//
// Created by Matt Darnall on 2019-03-11.
// Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation
import ReactiveSwift

public extension Signal {
  /**
   Transforms the signal into one that observes values on the UI thread.

   - returns: A new signal.
   */
  func observeForUI() -> Signal<Value, Error> {
    signal.observe(on: UIScheduler())
  }

  /**
   Transforms the signal into one that can perform actions for a controller. Use this operator when doing
   any side-effects from a controller. We've found that `UIScheduler` can be problematic with many
   controller actions, such as presenting and dismissing of view controllers.

   - returns: A new signal.
   */
  func observeForControllerAction() -> Signal<Value, Error> {
    signal.observe(on: QueueScheduler.main)
  }

  /*
   Transforms a signal to display async on a small
   delay so that `reloadData()` doesn't interfere

   see: https://stackoverflow.com/questions/28560068/uirefreshcontrol-endrefreshing-is-not-smooth
   */
  func observeForTableView() -> Signal<Value, Error> {
    signal.delay(0.3, on: QueueScheduler.main)
  }
}

public extension SignalProducerProtocol {
  /**
   Transforms the producer into one that observes values on the UI thread.

   - returns: A new producer.
   */
  func observeForUI() -> SignalProducer<Value, Error> {
    producer.observe(on: UIScheduler())
  }
}
