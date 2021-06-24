//
//  NorthDetailCell.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 6/24/21.
//

import Foundation
import SwiftUI
import ReactiveCocoa
import ReactiveSwift

struct NorthDetailCell: View {
  let store: StoreViewData
  @State private var indicatorColor: Color = Color.black
  var body: some View {
    HStack {
      VStack (alignment: .leading) {
        Text(store.storeName).font(.body)
        Text(store.storePhone).font(.caption)
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text(store.storeAddress).font(.footnote)
        Text(store.city).font(.footnote)
      }
    }.foregroundColor(indicatorColor)
    .onAppear {
      store.appointmentData.startWithResult { result in
        switch result {
        case .success(let data):
          determineColor(with: data)
        case .failure(let error):
          print(error)
          indicatorColor = Color.gray
        }
      }
    }
  }
  
  private func determineColor(with data: DataType<AppointmentData>) {
    let slots = data.Data.slots
    let availableSlots = slots.filter{ $0.value }
    if availableSlots.count > 0 {
      indicatorColor = Color.blue
    } else {
      indicatorColor = Color.red
    }
  }
  
}

struct NorthDetailCell_Previews: PreviewProvider {
    static var previews: some View {
      let store = StoreViewData.init(id: 12345, storeName: "Store Number: 343", storeAddress: "12345 Main Street", storePhone: "(419)567-3456", city: "Clarksville", appointmentData: .never)
      return NorthDetailCell(store: store)
    }
}
