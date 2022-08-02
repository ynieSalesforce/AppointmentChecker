//
//  WeatherComposableView.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 8/2/22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct WeatherComposableView: View {
  let store: Store<WeatherState, WeatherAction>
  @State private var cityText: String = ""
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          TextField("e.g. Cupertino", text: $cityText)
            .padding(.all, 8)
            .textFieldStyle(.roundedBorder)
          Button("Search") {
            viewStore.send(.updateCity(city: cityText))
          }.padding(.trailing, 8)
            .disabled(viewStore.isLoading)
        }
        
        if let current = viewStore.state.currentWeather {
          CurrentWeatherView(currentWeather: current)
        }
        
        if let weeklyWeather = viewStore.state.weeklyWeatherState {
          WeeklyWeatherView(weeklyWeather: weeklyWeather)
        }
        Spacer()
      }
    }
  }
}

struct CurrentWeatherView: View {
  @State var currentWeather: CurrentWeatherForecastResponse
  
  var body: some View {
    VStack {
      Text("Max Temp: \(currentWeather.main.maxTemperature)")
      Text("Max Temp: \(currentWeather.main.minTemperature)")
    }
  }
}

struct WeeklyWeatherView: View {
  @State var weeklyWeather: WeeklyForecastResponse
  
  var body: some View {
    List {
      ForEach(weeklyWeather.list.map(DailyWeatherRowViewModel.init), content: DailyWeatherRow.init(viewModel:))
    }
  }
}

struct DailyWeatherRow: View {
  private let viewModel: DailyWeatherRowViewModel
  
  init(viewModel: DailyWeatherRowViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack {
      VStack {
        Text("\(viewModel.day)")
        Text("\(viewModel.month)")
      }
      
      VStack(alignment: .leading) {
        Text("\(viewModel.title)")
          .font(.body)
        Text("\(viewModel.fullDescription)")
          .font(.footnote)
      }
        .padding(.leading, 8)

      Spacer()

      Text("\(viewModel.temperature)°")
        .font(.title)
    }
  }
}
