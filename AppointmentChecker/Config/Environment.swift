//
//  Environment.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import ReactiveSwift

public struct Environment {
  var scheduler: DateScheduler = QueueScheduler(qos: .userInitiated, name: "com.yuchenNie.userInitiated")
  var apiClient: APIClient = APIClient()
  var dataLoader: DataServiceType = DataService()
  var keychainService: KeychainService = KeychainService()
}

public extension Environment {
  static var current = Environment()
}
