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
        URLQueryItem(name: "address", value: location),
        URLQueryItem(name: "attrFilter", value: "PREF-112"),
        URLQueryItem(name: "fetchMechanismVersion", value: "2")
      ]
    case .CheckAppointments(let storeNumber):
      components.queryItems = [
        URLQueryItem(name: "storeNumber", value: storeNumber)
      ]
    case .WeeklyWeather(city: let city):
        components.queryItems = [
          URLQueryItem(name: "q", value: city),
          URLQueryItem(name: "mode", value: "json"),
          URLQueryItem(name: "units", value: "metric"),
          URLQueryItem(name: "APPID", value: "3e57f467e502f3d9292d00616d020888")
        ]
    case .CurrentWeather(city: let city):
        components.queryItems = [
          URLQueryItem(name: "q", value: city),
          URLQueryItem(name: "mode", value: "json"),
          URLQueryItem(name: "units", value: "metric"),
          URLQueryItem(name: "APPID", value: "3e57f467e502f3d9292d00616d020888")
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
  
  static func availableAppoints(for criteria: LoadCriteria) -> DataQuery? {
    guard let storeId = criteria.loadInput.storeId else {
      return .none
    }
    return .init(type: .CheckAppointments(storeNumber: storeId), method: .get, decoder: .decodable)
  }
    
    static func currentWeather(for city: String) -> DataQuery? {
        .init(type: .CurrentWeather(city: city), method: .get, decoder: .decodable)
    }
    
    static func weeklyWeather(for city: String) -> DataQuery? {
        .init(type: .WeeklyWeather(city: city), method: .get, decoder: .decodable)
    }
}

