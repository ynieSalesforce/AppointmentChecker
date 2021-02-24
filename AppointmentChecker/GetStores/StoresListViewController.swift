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
import SnapKit

class StoresListViewController: BaseViewController {
  let (addressSignal, addressObserver) = Signal<String, Never>.pipe()
  private var stores: [Store] = []
  
  lazy var addressHeader: EnterAddressHeader = {
    let header = EnterAddressHeader.init(addressObserver: addressObserver)
    view.addSubview(header)
    return header
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.estimatedRowHeight = 44
    tableView.dataSource = self
    tableView.delegate = self
    tableView.hideUnusedRow()
    tableView.separatorInset = .zero
    tableView.contentInsetAdjustmentBehavior = .never
    view.addSubview(tableView)
    return tableView
  }()
  
  override func bindViewModel() {
    let output = StoresListViewModel.create(input: .init(address: addressSignal, refresh: .never))
    output.data.observeForUI().observeValues { [weak self] data in
      self?.stores = data.Data.stores
    }
    
    output.dataLoadError.observeForUI().observeValues { error in
      print(error)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Search Locations"
    edgesForExtendedLayout = []
  }
  
  override func updateViewConstraints() {
    addressHeader.snp.updateConstraints { (make) in
      make.leading.top.trailing.equalToSuperview()
    }
    tableView.snp.updateConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(addressHeader.snp.bottom)
    }
    super.updateViewConstraints()
  }
}

extension StoresListViewController: UITableViewDelegate {
  
}

extension StoresListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell.init(frame: .zero)
  }
}
