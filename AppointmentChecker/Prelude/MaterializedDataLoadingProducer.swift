//
// Created by Matt Darnall on 2019-05-31.
// Copyright (c) 2019 Salesforce.com. All rights reserved.
//

import ReactiveSwift

/*
 These types are generic alias for `materialized` SignalProducers that can send a stream
 of Events

 We use these to have a distinct output for data vs. errors so that if we encounter an error our data stream doesn't terminate
 and allows the user to try again.
 */
public typealias MaterializedSignalProducer<Value, Error: Swift.Error> = SignalProducer<SignalProducer<Value, Error>.ProducedSignal.Event, Never>
public typealias MaterializedDataLoadingProducer<Value> = MaterializedSignalProducer<Value, DataLoadingError>
