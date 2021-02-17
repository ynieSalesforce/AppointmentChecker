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
  
  init(radius: Int? = nil, location: String? = nil) {
    self.radius = radius
    self.location = location
  }
}

struct LoadCriteria {
  let loadInput: LoadInput
  let forceRefresh: Bool
}
