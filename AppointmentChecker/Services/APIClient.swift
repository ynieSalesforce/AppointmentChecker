//
//  APIClient.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/16/21.
//

import Foundation
import Alamofire
import ReactiveSwift

public typealias APIResponse = SignalProducer<Data, DataLoadingError>

public struct APIClient {
  var fetch: (URL?) -> APIResponse = sendRequest
}

private func sendRequest(request: URL?) -> APIResponse {
  SignalProducer<Data, DataLoadingError> { observer, _ in
    guard let url = request else {
      observer.send(error: .networkError)
      observer.sendCompleted()
      return
    }
    AF.request(url) { urlRequest in
      urlRequest.timeoutInterval = 5
      urlRequest.allowsConstrainedNetworkAccess = false
    }.responseData { response in
      switch response.result {
      case let .success(data):
        observer.send(value: data)
      case let .failure(error):
        let statusCode = error.responseCode ?? 400
        observer.send(error: .errorWithStatusCode(statusCode))
      }
      observer.sendCompleted()
    }
  }
}
