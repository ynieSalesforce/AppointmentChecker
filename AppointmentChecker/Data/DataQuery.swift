//
//  DataService.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import Alamofire

struct DataQuery<Response> where Response: Decodable {
  let type: RequestType
  let method: HTTPMethod
  let decoder: ResponseDecoding<Response>
}

extension DataQuery {
  var urlString: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = type.host
    components.path = type.path
    switch type {
    case let .RetrieveStores(radius, location):
      components.queryItems = [
        URLQueryItem(name: "radius", value: "\(radius)"),
        URLQueryItem(name: "location", value: location)
      ]
    }
    return components.url
  }
}

extension DataQuery {
  static func riteAidLocations(for criteria: LoadCriteria) -> DataQuery?{
    guard let radius = criteria.loadInput.radius, let location = criteria.loadInput.location else {
      return .none
    }
    return .init(type: .RetrieveStores(radius: radius, location: location), method: .get, decoder: .decodable)
  }
}
