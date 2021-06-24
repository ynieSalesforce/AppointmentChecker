//
//  DetailScreen.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 6/22/21.
//

import Foundation
import SwiftUI
import ReactiveCocoa
import ReactiveSwift

struct DetailScreen: View {
  @ObservedObject var detailModel: DetailModel
  let addressObserver: Signal<String, Never>.Observer
  @State private var searchText: String = ""
  
  init(detailModel: DetailModel,
       addressObserver: Signal<String, Never>.Observer) {
    self.detailModel = detailModel
    self.addressObserver = addressObserver
  }
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          
        }
        HStack {
          TextField("Enter a Zipcode", text: $searchText).padding()
          Button("Search") {
            print("searchTexT: \(searchText)")
            addressObserver.send(value: searchText)
          }.padding()
        }
        retrieveView
        if !detailModel.northStores.isEmpty {
          northListView
        }
      }
    }
  }
  
  @ViewBuilder private var retrieveView: some View {
    if detailModel.loading {
      LoadingView()
      Spacer()
    } else {
      northListView
    }
  }
  
  @ViewBuilder private var northListView: some View {
    List {
      ForEach(detailModel.northStores) { section in
        Text(section.locationName)
        
        ForEach(section.stores) { store in
          DetailCell(store: store)
        }
      }
    }
  }
}

struct DetailScreen_Previews: PreviewProvider {
    static var previews: some View {
      let address = Signal<String, Never>.pipe()
      let stores: [StoreViewData] = [
        StoreViewData.init(id: 12345, storeName: "Clarksville", storeAddress: "1234 Main Street", storePhone: "445-987-7485", city: "Clarksville", appointmentData: .never),
        StoreViewData.init(id: 45678, storeName: "Columbia", storeAddress: "4434 Main Street", storePhone: "445-937-7485", city: "Columbia", appointmentData: .never),
      ]
      let model = DetailModel.init()
      model.centerStores = [
        LocationViewData.init(stores: stores, locationName: "Columbia, MD")
      ]
      model.loading = false
      model.error = nil
      return DetailScreen(detailModel: model, addressObserver: address.input)
    }
}
