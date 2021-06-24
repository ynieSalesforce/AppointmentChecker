//
//  DetailViewController.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 6/22/21.
//

import Foundation
import UIKit
import SwiftUI
import ReactiveSwift
import ReactiveCocoa

class DetailViewController: BaseViewController {
  let (addressSignal, addressObserver) = Signal<String, Never>.pipe()
  var detailModel: DetailModel = .init()
  override func bindViewModel() {
    let output = StoresListViewModel.create(input: .init(lifeCycle: lifecycle,
                                                         address: addressSignal, refresh: refreshControl.refresh))
    output.data.observeForUI().observeValues { [weak self] data in
      self?.detailModel.stores = [data.0]
    }
    
    output.dataIsLoading.observeForUI().observeValues { isLoading in
      self.detailModel.loading = isLoading
    }
    
    output.dataLoadError.observeForUI().observeValues { error in
      self.detailModel.error = error
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let hosting = UIHostingController(rootView: DetailScreen(detailModel: detailModel, addressObserver: addressObserver))
    addChild(hosting)
    view.addSubview(hosting.view)
    hosting.didMove(toParent: self)
    hosting.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      hosting.view.widthAnchor.constraint(equalTo: view.widthAnchor),
      hosting.view.heightAnchor.constraint(equalTo: view.heightAnchor),
      hosting.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      hosting.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}
