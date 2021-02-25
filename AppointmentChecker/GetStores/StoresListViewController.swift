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
  private var stores: [StoreViewData] = []
  
  lazy var addressHeader: EnterAddressHeader = {
    let header = EnterAddressHeader.init(addressObserver: addressObserver)
    view.addSubview(header)
    return header
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseID)
    tableView.estimatedRowHeight = 44
    tableView.dataSource = self
    tableView.delegate = self
    tableView.hideUnusedRow()
    tableView.separatorInset = .zero
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.refreshControl = refreshControl
    view.addSubview(tableView)
    return tableView
  }()
  
  override func bindViewModel() {
    let output = StoresListViewModel.create(input: .init(address: addressSignal, refresh: refreshControl.refresh))
    output.data.observeForUI().observeValues { [weak self] data in
      self?.stores = data.stores
      self?.tableView.reloadData()
    }
    
    output.dataLoadError.observeForUI().observeValues { error in
      print(error)
    }
    refreshControl.reactive.isRefreshing <~ output.isRefreshing
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
    self.stores.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseID, for: indexPath) as? LocationCell else {
      return UITableViewCell.init(frame: .zero)
    }
    let store = stores[indexPath.row]
    cell.configure(with: store)
    return cell
  }
}
