//
//  WeatherReducer.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 8/1/22.
//

import Foundation
import ComposableArchitecture
import ReactiveSwift
import ReactiveCocoa
import Combine

struct WeatherEnvironment {
    let fetcher = WeatherFetcher()
}

let weatherReducer = Reducer<
WeatherState,
WeatherAction,
WeatherEnvironment
> { state, action, environment in
    switch action {
    case .updateCity(city: let city):
        state.isLoading = true
        let currentWeather = retrieveCurrentWeatherEffect(from: city, environment: environment).catchToEffect().map(WeatherAction.currentDataLoaded)
        let weeklyWeather = retrieveWeeklyWeatherEffect(from: city, environment: environment).catchToEffect().map(WeatherAction.weeklyDataLoaded)
        return .merge(currentWeather, weeklyWeather)
    case .weeklyDataLoaded(let result):
        state.isLoading = false
        switch result {
        case .success(let weekly):
            state.weeklyWeatherState = weekly
        case .failure(let error):
            print("error: \(error.localizedDescription)")
        }
        return .none
    case .currentDataLoaded(let result):
        state.isLoading = false
        switch result {
        case .success(let current):
            state.currentWeather = current
        case .failure(let error):
            print("error: \(error.localizedDescription)")
        }
        return .none
    }
}

private func retrieveCurrentWeatherEffect(from city: String, environment: WeatherEnvironment)
-> AnyPublisher<CurrentWeatherForecastResponse, DataLoadingError> {
    let property = PassthroughSubject<CurrentWeatherForecastResponse, DataLoadingError>()
    environment.fetcher.currentWeatherForecast(forCity: city)
        .startWithResult({ result in
        switch result{
        case .success(let value):
            property.send(value)
        case .failure(let error):
            property.send(completion: .failure(error))
        }
    })
    return property.eraseToAnyPublisher()
}

private func retrieveWeeklyWeatherEffect(from city: String, environment: WeatherEnvironment)
-> AnyPublisher<WeeklyForecastResponse, DataLoadingError> {
    let property = PassthroughSubject<WeeklyForecastResponse, DataLoadingError>()
    environment.fetcher.weeklyWeatherForecast(forCity: city)
        .startWithResult({ result in
        switch result{
        case .success(let value):
            property.send(value)
        case .failure(let error):
            property.send(completion: .failure(error))
        }
    })
    return property.eraseToAnyPublisher()
}

public struct ReactiveSwiftPublisher<Element>: Publisher {
    public typealias Output = Element
    public typealias Failure = Never

    /// Subscription for ReactiveSwiftPublisher
    class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == Element {
        private var disposable: Disposable?

        init(producer: SignalProducer<Element, Failure>, subscriber: SubscriberType) {
            self.disposable = producer.startWithValues({
                _ = subscriber.receive($0)
            })
        }

        deinit {
            self.disposable?.dispose()
        }

        func request(_ demand: Subscribers.Demand) {}
        func cancel() {
            self.disposable?.dispose()
        }
    }

    private let producer: SignalProducer<Element, Failure>

    public init(producer: SignalProducer<Element, Failure>) {
        self.producer = producer
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(producer: self.producer, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
