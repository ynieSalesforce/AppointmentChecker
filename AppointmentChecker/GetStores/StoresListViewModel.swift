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
    let data: Signal<DataType<StoreList>, Never>
    let dataIsLoading: Signal<Bool, Never>
    let isRefreshing: Signal<Bool, Never>
    let dataLoadError: Signal<DataLoadingError, Never>
  }

  struct Input {
    var address: Signal<String, Never>
    var refresh: TriggerSignal
  }
  
  static func create(input: Input) -> Output {
    let scheduler = Environment.current.scheduler
    
    let refresh = input.refresh.withLatest(from: input.address)
      .map { $0.1 }
      .map(addressQuery)
      .skipNil()
      .map(retrieveData)
    
    let address = input.address.observe(on: scheduler)
      .map(addressQuery)
      .skipNil()
      .map(retrieveData)
    
    let (addressLoading, addressData) = switchMapWithIndicator(address)
    let (refreshing, refreshedData) = switchMapWithIndicator(refresh)
    
    let data = Signal.merge(addressData.values(), refreshedData.values())
    let errors = Signal.merge(addressData.errors(), refreshedData.errors())
    
    return .init(data: data,
                 dataIsLoading: addressLoading,
                 isRefreshing: refreshing,
                 dataLoadError: errors)
  }
}

private func addressQuery(for address: String) -> DataQuery<DataType<StoreList>>? {
  let criteria: LoadCriteria = .init(loadInput: .init(radius: 50, location: address), forceRefresh: true)
  return DataQuery.riteAidLocations(for: criteria)
}

private func retrieveData(query: DataQuery<DataType<StoreList>>) -> MaterializedDataLoadingProducer<DataType<StoreList>>{
  Environment.current.dataLoader.retrieve(query).materialize()
}
