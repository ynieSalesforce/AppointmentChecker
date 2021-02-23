//
//  StoresListViewModel.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import Overture
import ReactiveSwift

public struct StoresListViewModel {
  struct Output {
    let dataIsLoading: Signal<Bool, Never>
    let dataLoadError: Signal<DataLoadingError, Never>
  }

  struct Input {
    let lifeCycle: ViewLifeCycle
    var address: Signal<String, Never>
    var refresh: TriggerSignal
  }
  
  static func create(input: Input) -> Output {
    let scheduler = Environment.current.scheduler
    let onLoad = input.lifeCycle.viewDidLoadProperty.signal.observe(on: scheduler)
    
    
  }
}

