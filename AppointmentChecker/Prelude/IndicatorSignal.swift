//
// Created by Matt Darnall on 2019-03-28.
// Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation
import ReactiveSwift

/*
 Helper to take a SignalProducer to be `switchMapped`, while also returning a Signal used to
 indicate when the work is being done in the given producer.
 */
func switchMapWithIndicator<V, E>(_ signal: Signal<SignalProducer<V, E>, Never>) -> (Signal<Bool, Never>, Signal<V, E>) {
  let indicator = MutableProperty<Bool>(false)
  let indicatingSignal = signal.flatMap(.latest) {
    $0.on(starting: { [weak indicator] in
      indicator?.value = true
    }, terminated: { [weak indicator] in
      indicator?.value = false
    }, value: { [weak indicator] _ in
      indicator?.value = false
    })
  }
  return (indicator.signal.skipRepeats(), indicatingSignal)
}
