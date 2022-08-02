//
//  Request.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import Alamofire

enum RequestType {
  case RetrieveStores(radius: Int, location: String)
  case CheckAppointments(storeNumber: String)
    case WeeklyWeather(city: String)
    case CurrentWeather(city: String)
}

extension RequestType {
  var host: String {
    switch self {
    case .RetrieveStores, .CheckAppointments:
      return "www.riteaid.com"
    case .WeeklyWeather, .CurrentWeather:
        return "api.openweathermap.org"
    }
  }
  
  var path: String {
    switch self {
    case .RetrieveStores:
      return "/services/ext/v2/stores/getStores"
    case .CheckAppointments:
      return "/services/ext/v2/vaccine/checkSlots"
    case.WeeklyWeather:
        return "/data/2.5/forecast"
    case .CurrentWeather:
        return "/data/2.5/weather"
    }
  }
}
