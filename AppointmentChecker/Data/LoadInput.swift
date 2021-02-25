//
//  LoadCriteria.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/16/21.
//

import Foundation

struct LoadInput {
  let radius: Int?
  let location: String?
  let storeId: String?
  
  init(radius: Int? = nil, location: String? = nil, storeId: String? = nil) {
    self.radius = radius
    self.location = location
    self.storeId = storeId
  }
}

struct LoadCriteria {
  let loadInput: LoadInput
  let forceRefresh: Bool
}
