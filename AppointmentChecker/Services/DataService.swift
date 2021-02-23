//
//  DataService.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/23/21.
//

import Foundation
import ReactiveSwift

protocol DataServiceType {
  func retrieve<T: Decodable> (_ request: DataQuery<T>) -> DataProducer<T>
}

typealias DataProducer<T: Decodable> = SignalProducer<T, DataLoadingError>

class DataService: DataServiceType {
  private var decoder = JSONDecoder()
  
  func retrieve<T>(_ request: DataQuery<T>) -> DataProducer<T> where T : Decodable {
    Environment.current.apiClient
      .fetch(request.urlString)
      .flatMap(.merge, request.decoder.decode)
  }
}
