//
//  StoresListViewModel.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import Overture
import ReactiveSwift
import MapKit

struct LocationViewData {
  let stores: [StoreViewData]
  let locationName: String
}

struct StoreViewData {
  let storeName: String
  let storeAddress: String
  let storePhone: String
  let city: String
  
  let appointmentData: SignalProducer<DataType<AppointmentData>, DataLoadingError>
}

//Distance to search to in miles
private let expandedDistance: Double = 30

public struct StoresListViewModel {
  struct Output {
    let data: Signal<(LocationViewData, (LocationViewData, LocationViewData, LocationViewData, LocationViewData)), Never>
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

    let dataOnLoad = onLoad.map(retrieveSavedLocation).flatMap(.latest, convertStringToLocation)
    let refresh = input.refresh.withLatest(from: input.address).map { $0.1 }
      .flatMap(.latest, convertStringToLocation)
    let inputAddress = input.address.observe(on: scheduler).flatMap(.latest, convertStringToLocation)
    
    
    let initialSurroundLocations = dataOnLoad.map(getSurroundingCoordinates).map(transform).ignoreErrors()
    let refreshSurroundLocations = refresh.map(getSurroundingCoordinates).map(transform).ignoreErrors()
    let inputSurroundLocations = inputAddress.map(getSurroundingCoordinates).map(transform).ignoreErrors()
    
    let (initialLoading, initialSurroundingValues) = switchMapWithIndicator(initialSurroundLocations)
    let (refreshing, refreshSurroundValues) = switchMapWithIndicator(refreshSurroundLocations)
    let (inputLoading, inputSurroundValues) = switchMapWithIndicator(inputSurroundLocations)
    
    let errors = Signal.merge(initialSurroundingValues.materialize().errors(),
                              refreshSurroundValues.materialize().errors(),
                              inputSurroundValues.materialize().errors())
    
    let loadingData = Signal.merge(initialLoading, inputLoading)
    
    let combinedInitialValues = dataOnLoad.map(toViewData).combineLatest(with: initialSurroundingValues)
    let combinedRefreshValues = refresh.map(toViewData).combineLatest(with: refreshSurroundValues)
    let combinedInputValues = inputAddress.map(toViewData).combineLatest(with: inputSurroundValues)
    
    let dataSum = Signal.merge(combinedInitialValues, combinedRefreshValues, combinedInputValues).ignoreErrors()
    
    return .init(data: dataSum,
                 dataIsLoading: loadingData,
                 isRefreshing: refreshing,
                 dataLoadError: errors,
                 savedValue: Environment.current.keychainService.getValue(.Address))
  }
}

private func transform(input: [SignalProducer<String?, Never>]) -> SignalProducer<(LocationViewData, LocationViewData, LocationViewData, LocationViewData), DataLoadingError>{
  let getAddressQuery = curry(addressQuery)(false)

  let inputArray = input.map{$0.skipNil()
    .map(getAddressQuery)
    .skipNil()
    .flatMap(.latest, retrieveData)
  }
  let north = inputArray[0].map(toViewData)
  let south = inputArray[1].map(toViewData)
  let west = inputArray[2].map(toViewData)
  let east = inputArray[3].map(toViewData)
  
  let lat = north.combineLatest(with: south)
  let long = east.combineLatest(with: west)
  let sum = lat.combineLatest(with: long).compactMap { (data) -> (LocationViewData, LocationViewData, LocationViewData, LocationViewData) in
    return (data.0.0, data.0.1, data.1.0, data.1.1)
  }
  return sum
}

private func convertStringToLocation(inputString: String?) -> DataProducer<DataType<StoreList>>{
  let getAddressQuery = curry(addressQuery)(true)
  return SignalProducer.init(value: inputString)
    .skipNil()
    .map(getAddressQuery)
    .skipNil()
    .flatMap(.latest, retrieveData).producer
}

private func retrieveSavedLocation() -> String? {
  Environment.current.keychainService.getValue(.Address)
}

private func addressQuery(saveToDisk: Bool, address: String) -> DataQuery<DataType<StoreList>>? {
  if saveToDisk {
    Environment.current.keychainService.setValue(address, .Address)
  }
  let criteria: LoadCriteria = .init(loadInput: .init(radius: 50, location: address), forceRefresh: true)
  return DataQuery.riteAidLocations(for: criteria)
}

private func retrieveData(query: DataQuery<DataType<StoreList>>) -> DataProducer<DataType<StoreList>>{
  Environment.current.dataLoader.retrieve(query)
}

private func toViewData(storeData: DataType<StoreList>) -> LocationViewData {
  let stores = storeData.Data.stores.map(storeToStoreViewData)
  let city = storeData.Data.resolvedAddress.locality
  let state = storeData.Data.resolvedAddress.adminDistrict
  let location = " \(city), \(state)"
  return .init(stores: stores, locationName: location)
}

private func storeToStoreViewData(store: StoreData) -> StoreViewData {
  let loadCriteria = LoadCriteria.init(loadInput: .init(storeId: "\(store.storeNumber)"), forceRefresh: true)
  let query: DataQuery<DataType<AppointmentData>>? = DataQuery.availableAppoints(for: loadCriteria)
  let appointment = Environment.current.dataLoader.retrieve(query!)
  let city = "City: \(store.city)"
  
  return .init(storeName: "Store Number: \(store.storeNumber)", storeAddress: store.address, storePhone: store.fullPhone, city: city, appointmentData: appointment)
}

private func getSurroundingCoordinates(from store: DataType<StoreList>) -> [SignalProducer<String?, Never>]{
  let lat = store.Data.resolvedAddress.latitude
  let long = store.Data.resolvedAddress.longitude
  
  let location = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
  let locationCalculator = curry(calculateLatLong)(location)
  
  let northLocation = locationCalculator(expandedDistance)(0)
  let southLocation = locationCalculator(-expandedDistance)(0)
  let eastLocation = locationCalculator(0)(-expandedDistance)
  let westLocation = locationCalculator(0)(expandedDistance)
  
  return [northLocation, southLocation, eastLocation, westLocation]
}

private func calculateLatLong(currentLocation: CLLocationCoordinate2D, north: Double, west: Double)
-> SignalProducer<String?, Never> {
  SignalProducer<String?, Never> { observer , _ in
    let circumferenceEarth: Double = 6378137
    
    let newLat = currentLocation.latitude + (180/Double.pi) * (milesToMeters(miles: north)/circumferenceEarth)
    let newLong = currentLocation.longitude + (180/Double.pi) * (milesToMeters(miles: west)/circumferenceEarth)/cos(Double.pi/180*currentLocation.latitude)
    
    let location = CLLocation.init(latitude: newLat, longitude: newLong)
    let locator = CLGeocoder.init()
    
    locator.reverseGeocodeLocation(location) { placeMark, error in
      guard let zipCode = placeMark?.first?.postalCode else {
        observer.send(value: nil)
        observer.sendCompleted()
        return
      }
      observer.send(value: zipCode)
      observer.sendCompleted()
    }
  }
}

private func milesToMeters(miles: Double) -> Double {
  miles * 1.601 * 1000
}
