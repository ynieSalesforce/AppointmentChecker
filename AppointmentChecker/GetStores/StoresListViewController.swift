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
  private var locations: [LocationViewData] = []
  
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
    let output = StoresListViewModel.create(input: .init(lifeCycle: lifecycle,
                                                         address: addressSignal,
                                                         refresh: refreshControl.refresh))
    output.data.observeForUI().observeValues { [weak self] data in
      var storeArray: [LocationViewData] = [data.0]
      storeArray.append(data.1.0)
      storeArray.append(data.1.1)
      storeArray.append(data.1.2)
      storeArray.append(data.1.3)
      
      self?.locations = storeArray
      self?.tableView.reloadData()
    }
    
    output.dataLoadError.observeForUI().observeValues { error in
      print(error)
    }
    
    addressHeader.setSavedAddress(output.savedValue)
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let detailView = DetailViewController()
    navigationController?.pushViewController(detailView, animated: true)
  }
}

extension StoresListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.locations[section].locationName
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.locations.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.locations[section].stores.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseID, for: indexPath) as? LocationCell else {
      return UITableViewCell.init(frame: .zero)
    }
    let store = locations[indexPath.section].stores[indexPath.row]
    cell.configure(with: store)
    return cell
  }
}
