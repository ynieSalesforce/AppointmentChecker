///Test

import Foundation
import Combine
import ReactiveSwift

protocol WeatherFetchable {
  func weeklyWeatherForecast(forCity city: String) -> DataProducer<WeeklyForecastResponse>
  func currentWeatherForecast(forCity city: String) -> DataProducer<CurrentWeatherForecastResponse>
}

class WeatherFetcher {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

extension WeatherFetcher: WeatherFetchable {
    func weeklyWeatherForecast(forCity city: String) -> DataProducer<WeeklyForecastResponse> {
        guard let query = DataQuery<WeeklyForecastResponse>.weeklyWeather(for: city) else {
            return .init(error: .networkError)
        }
        return Environment.current.dataLoader.retrieve(query)
    }
    
    func currentWeatherForecast(forCity city: String) -> DataProducer<CurrentWeatherForecastResponse> {
        guard let query = DataQuery<CurrentWeatherForecastResponse>.currentWeather(for: city) else {
            return .init(error: .networkError)
        }
        return Environment.current.dataLoader.retrieve(query)
    }
  
  private func handleError(urlError: URLError) -> WeatherError {
    .network(description: urlError.localizedDescription)
  }
}

// MARK: - OpenWeatherMap API
private extension WeatherFetcher {
  struct OpenWeatherAPI {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5"
    ///Enter API Key
    static let key = "3e57f467e502f3d9292d00616d020888"
  }
  
  func makeWeeklyForecastComponents(
    withCity city: String
  ) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/forecast"
    
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
  
  func makeCurrentDayForecastComponents(
    withCity city: String
  ) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/weather"
    
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
}

enum WeatherError: Error {
  case parsing(description: String)
  case network(description: String)
}

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, WeatherError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
