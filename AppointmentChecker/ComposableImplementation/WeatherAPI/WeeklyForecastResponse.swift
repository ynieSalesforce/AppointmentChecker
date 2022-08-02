///Test

import Foundation

struct WeeklyForecastResponse: Codable, Equatable {
  let list: [Item]
  
  struct Item: Codable, Equatable {
    let date: Date
    let main: MainClass
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
      case date = "dt"
      case main
      case weather
    }
  }
  
  struct MainClass: Codable, Equatable {
    let temp: Double
  }
  
  struct Weather: Codable, Equatable {
    let main: MainEnum
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
      case main
      case weatherDescription = "description"
    }
  }
  
  enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
  }
}

struct CurrentWeatherForecastResponse: Decodable, Equatable {
  let coord: Coord
  let main: Main
  
  struct Main: Codable, Equatable {
    let temperature: Double
    let humidity: Int
    let maxTemperature: Double
    let minTemperature: Double
    
    enum CodingKeys: String, CodingKey {
      case temperature = "temp"
      case humidity
      case maxTemperature = "temp_max"
      case minTemperature = "temp_min"
    }
  }
  
  struct Coord: Codable, Equatable {
    let lon: Double
    let lat: Double
  }
}
