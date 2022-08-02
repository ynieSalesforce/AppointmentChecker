//
//  WeatherActions.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 8/1/22.
//

import Foundation

struct WeatherData {
    let current: CurrentWeatherForecastResponse
    let weekly: WeeklyForecastResponse
}

enum WeatherAction: Equatable {
    static func == (lhs: WeatherAction, rhs: WeatherAction) -> Bool {
        switch lhs {
        case .updateCity:
            switch rhs {
            case .updateCity:
                return true
            default:
                return false
            }
        case .weeklyDataLoaded:
            switch rhs {
            case .weeklyDataLoaded:
                return true
            default:
                return false
            }
        case .currentDataLoaded:
            switch rhs {
            case .currentDataLoaded:
                return true
            default:
                return false
            }
//        case .weatherDataLoaded:
//            switch rhs {
//            case .weatherDataLoaded:
//                return true
//            default:
//                return false
//            
//            }
        }
    }
    
    case updateCity(city: String)
    //case weatherDataLoaded(Result<WeatherData, DataLoadingError>)
    case weeklyDataLoaded(Result<WeeklyForecastResponse, DataLoadingError>)
    case currentDataLoaded(Result<CurrentWeatherForecastResponse, DataLoadingError>)
}
