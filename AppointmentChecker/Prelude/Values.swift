//
// Created by Matt Darnall on 2019-05-29.
// Copyright (c) 2019 Salesforce.com. All rights reserved.
//

import Foundation
import ReactiveSwift

public extension Signal where Value: EventProtocol, Error == Never {
  /**
   - returns: A signal of values of `Next` events from a materialized signal.
   */
  func values() -> Signal<Value.Value, Never> {
    signal.map { $0.event.value }.skipNil()
  }
}

public extension SignalProducer where Value: EventProtocol, Error == Never {
  /**
   - returns: A producer of values of `Next` events from a materialized signal.
   */
  func values() -> SignalProducer<Value.Value, Never> {
    lift { $0.values() }
  }
}
