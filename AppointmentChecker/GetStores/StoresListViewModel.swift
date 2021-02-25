//
//  StoresListViewModel.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import Overture
import ReactiveSwift

struct LocationViewData {
  let stores: [StoreViewData]
  let locationName: String
}

struct StoreViewData {
  let storeName: String
  let storeAddress: String
  let storePhone: String
  let distance: String
  
  let appointmentData: SignalProducer<DataType<AppointmentData>, DataLoadingError>
}

public struct StoresListViewModel {
  struct Output {
    let data: Signal<LocationViewData, Never>
    let dataIsLoading: Signal<Bool, Never>
    let isRefreshing: Signal<Bool, Never>
    let dataLoadError: Signal<DataLoadingError, Never>
    let savedValue: String?
  }

  struct Input {
    var lifeCycle: ViewLifeCycle
    var address: Signal<String, Never>
    var refresh: TriggerSignal
  }
  
  static func create(input: Input) -> Output {
    let scheduler = Environment.current.scheduler
    let onLoad = input.lifeCycle.viewDidLoadProperty.signal.observe(on: scheduler)
    
    let dataOnLoad = onLoad.map(retrieveSavedLocation)
      .skipNil()
      .map(addressQuery)
      .skipNil()
      .map(retrieveData)
    
    let refresh = input.refresh.withLatest(from: input.address)
      .map { $0.1 }
      .map(addressQuery)
      .skipNil()
      .map(retrieveData)
    
    let address = input.address.observe(on: scheduler)
      .map(addressQuery)
      .skipNil()
      .map(retrieveData)
    
    let (loading, loadData) = switchMapWithIndicator(dataOnLoad)
    let (addressLoading, addressData) = switchMapWithIndicator(address)
    let (refreshing, refreshedData) = switchMapWithIndicator(refresh)
    
    let data = Signal.merge(loadData.values().map(toViewData),
                            addressData.values().map(toViewData),
                            refreshedData.values().map(toViewData))
    
    let errors = Signal.merge(addressData.errors(), refreshedData.errors())
    let loadingData = Signal.merge(loading, addressLoading)
    
    return .init(data: data,
                 dataIsLoading: loadingData,
                 isRefreshing: refreshing,
                 dataLoadError: errors,
                 savedValue: Environment.current.keychainService.getValue(.Address))
  }
}

private func retrieveSavedLocation() -> String? {
  Environment.current.keychainService.getValue(.Address)
}

private func addressQuery(for address: String) -> DataQuery<DataType<StoreList>>? {
  Environment.current.keychainService.setValue(address, .Address)
  let criteria: LoadCriteria = .init(loadInput: .init(radius: 50, location: address), forceRefresh: true)
  return DataQuery.riteAidLocations(for: criteria)
}

private func retrieveData(query: DataQuery<DataType<StoreList>>) -> MaterializedDataLoadingProducer<DataType<StoreList>>{
  Environment.current.dataLoader.retrieve(query).materialize()
}

private func toViewData(storeData: DataType<StoreList>) -> LocationViewData {
  let stores = storeData.Data.stores.map(storeToStoreViewData)
  let location = storeData.Data.resolvedAddress.displayName
  return .init(stores: stores, locationName: location)
}

private func storeToStoreViewData(store: StoreData) -> StoreViewData {
  let loadCriteria = LoadCriteria.init(loadInput: .init(storeId: "\(store.storeNumber)"), forceRefresh: true)
  let query: DataQuery<DataType<AppointmentData>>? = DataQuery.availableAppoints(for: loadCriteria)
  let appointment = Environment.current.dataLoader.retrieve(query!)
  let distance = "Distance: \(store.milesFromCenter)mi"
  
  return .init(storeName: "Store Number: \(store.storeNumber)", storeAddress: store.address, storePhone: store.fullPhone, distance: distance, appointmentData: appointment)
}
