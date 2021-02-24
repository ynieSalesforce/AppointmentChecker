//
// Created by Matt Darnall on 2019-05-29.
// Copyright (c) 2019 Salesforce.com. All rights reserved.
//

import Foundation
import Overture
import ReactiveSwift

public extension Signal where Value: EventProtocol, Error == Never {
  /**
   - returns: A signal of errors of `Error` events from a materialized signal.
   */
  func errors() -> Signal<Value.Error, Never> {
    signal.map { $0.event.error }.skipNil()
  }
}

public extension SignalProducer where Value: EventProtocol, Error == Never {
  /**
   - returns: A producer of errors of `Error` events from a materialized signal.
   */
  func errors() -> SignalProducer<Value.Error, Never> {
    lift { $0.errors() }
  }
}

extension Signal where Error == DataLoadingError {
  func flatMapNotFound(to replacement: Value) -> Signal<Value, Error> {
    signal.flatMapError { error in
      return SignalProducer(error: error)
    }
  }
}

extension SignalProducer where Error == DataLoadingError {
  func flatMapNotFound(to replacement: Value) -> SignalProducer<Value, Error> {
    lift { $0.flatMapNotFound(to: replacement) }
  }
}
