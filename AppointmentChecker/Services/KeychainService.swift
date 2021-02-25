//
//  KeychainService.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/25/21.
//

import Foundation
import KeychainSwift

struct KeychainService {
  var getValue: (KeychainKey) -> String? = retrieveValue
  var setValue: (String, KeychainKey) -> () = set
}

public enum KeychainKey: String {
  public typealias RawValue = String
  
  case Address
}

private func retrieveValue(for key: KeychainKey) -> String? {
  let keychain = KeychainSwift()
  return keychain.get(key.rawValue)
}

private func set(_ value: String, for key: KeychainKey) {
  let keychain = KeychainSwift()
  if retrieveValue(for: key) == value {
    return
  }
  keychain.set(value, forKey: key.rawValue)
}
