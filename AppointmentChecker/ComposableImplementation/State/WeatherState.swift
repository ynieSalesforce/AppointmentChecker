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
