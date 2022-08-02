//
//  WeatherState.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 8/1/22.
//

import Foundation

struct WeatherState: Equatable {
    var currentWeather: CurrentWeatherForecastResponse?
    var weeklyWeatherState: WeeklyForecastResponse?
    var isLoading: Bool = false
}

struct DailyWeatherRowViewModel: Identifiable {
  private let item: WeeklyForecastResponse.Item
  
  var id: String {
    return day + temperature + title
  }
  
  var day: String {
    return dayFormatter.string(from: item.date)
  }
  
  var month: String {
    return monthFormatter.string(from: item.date)
  }
  
  var temperature: String {
    return String(format: "%.1f", item.main.temp)
  }
  
  var title: String {
    guard let title = item.weather.first?.main.rawValue else { return "" }
    return title
  }
  
  var fullDescription: String {
    guard let description = item.weather.first?.weatherDescription else { return "" }
    return description
  }
  
  init(item: WeeklyForecastResponse.Item) {
    self.item = item
  }
}

let dayFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd"
  return formatter
}()

let monthFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMMM"
  return formatter
}()
