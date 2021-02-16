//
//  DataService.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import Alamofire

protocol DataServiceType {
  func handle(request: Request)
}

struct DataService: DataServiceType {
  func handle(request: Request) {
    
  }
}
