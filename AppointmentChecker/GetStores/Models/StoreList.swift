//
//  StoreList.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/23/21.
//

import Foundation

struct StoreList: Codable {
  let stores: [StoreData]
  let resolvedAddress: ResolvedAddress
}

struct ResolvedAddress: Codable {
  let displayName: String
  let latitude: Double
  let longitude: Double
  let locality: String
  let adminDistrict: String
}
