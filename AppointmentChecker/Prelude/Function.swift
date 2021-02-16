//
// Created by Matt Darnall on 2019-03-07.
// Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation

public func id<A>(_ a: A) -> A {
  a
}

public func const<A, B>(_ a: A) -> (B) -> A {
  // swift_lint:disable opening_brace
  { _ in a }
}
