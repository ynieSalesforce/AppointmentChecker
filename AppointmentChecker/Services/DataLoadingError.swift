//
// Created by Matt Darnall on 2019-03-06.
// Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation
import Overture
import ReactiveSwift

public enum DataLoadingError: Error {
  case unknown(String)
  case errorWithStatusCode(Int)
  case badResponse(Error?)
  case networkError
}

