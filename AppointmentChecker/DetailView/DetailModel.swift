//
//  DetailModel.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 6/23/21.
//

import Foundation
import SwiftUI

class DetailModel: ObservableObject {
  @Published var stores: [LocationViewData] = []
  @Published var loading: Bool = false
  @Published var error: DataLoadingError? = nil
}
