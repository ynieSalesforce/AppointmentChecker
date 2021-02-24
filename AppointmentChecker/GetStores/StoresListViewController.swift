//
//  StoresListViewController.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/15/21.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

class StoresListViewController: BaseViewController {
  let (addressSignal, addressObserver) = Signal<String, Never>.pipe()
  
  override func bindViewModel() {
    let output = StoresListViewModel.create(input: .init(address: addressSignal, refresh: .never))
  }
  
  
}
