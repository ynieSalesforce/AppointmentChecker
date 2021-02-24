//
//  StoreList.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/23/21.
//

import Foundation

struct StoreList: Codable {
  let stores: [Store]
  let latitude: Float
  let longitude: Float
}
