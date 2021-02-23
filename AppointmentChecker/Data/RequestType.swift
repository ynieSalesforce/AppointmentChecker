//
//  Request.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import Alamofire

enum RequestType {
  case RetrieveStores(radius: Int, location: String)
}

extension RequestType {
  var host: String {
    switch self {
    case .RetrieveStores:
      return "www.riteaid.com"
    }
  }
  
  var path: String {
    switch self {
    case .RetrieveStores:
      return "services/ext/v2/vaccine/checkSlots"
    }
  }
}
