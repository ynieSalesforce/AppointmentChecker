//
//  DataType.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/23/21.
//

import Foundation

struct DataType<T: Codable>: Codable {
  let Data: T
}
