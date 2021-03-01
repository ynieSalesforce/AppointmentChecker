//
//  Store.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/23/21.
//

import Foundation

struct StoreData: Codable {
  let storeNumber: Int
  let address: String
  let city: String
  let state: String
  let zipcode: String
  let fullPhone: String
  let locationDescription: String
  let milesFromCenter: Float
  
  let latitude: Double
  let longitude: Double
}
