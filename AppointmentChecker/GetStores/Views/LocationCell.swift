//
//  LocationCell.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/24/21.
//

import Foundation
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class LocationCell: UITableViewCell {
  static let reuseID: String = "LocationCellReuseID"
  
  private lazy var storeLabel: UILabel = {
    let label = UILabel()
    contentView.addSubview(label)
    return label
  }()
  
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    contentView.addSubview(label)
    return label
  }()
  
  private lazy var phoneLabel: UILabel = {
    let label = UILabel()
    contentView.addSubview(label)
    label.textAlignment = .right
    return label
  }()
  
  private lazy var distanceLabel: UILabel = {
    let label = UILabel()
    contentView.addSubview(label)
    label.textAlignment = .right
    label.font = .systemFont(ofSize: 10)
    label.textColor = .lightGray
    return label
  }()
  
  public func configure(with store: StoreViewData) {
    storeLabel.text = store.storeName
    addressLabel.text = store.storeAddress
    phoneLabel.text = store.storePhone
    distanceLabel.text = store.distance
    
    store.appointmentData.startWithResult { result in
      switch result {
      case .success(let data):
        self.handleSlots(slots: data.Data.slots)
      case .failure(let error):
        print(error)
        self.contentView.backgroundColor = .lightGray
      }
    }
    
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  override func updateConstraints() {
    storeLabel.snp.updateConstraints { (make) in
      make.leading.top.equalTo(contentView).inset(16)
    }
    addressLabel.snp.updateConstraints { (make) in
      make.leading.bottom.equalTo(contentView).inset(16)
      make.top.equalTo(storeLabel.snp.bottom).offset(10)
    }
    
    phoneLabel.snp.updateConstraints { (make) in
      make.trailing.top.equalTo(contentView).inset(16)
    }
    distanceLabel.snp.updateConstraints { (make) in
      make.trailing.equalTo(phoneLabel)
      make.top.equalTo(phoneLabel.snp.bottom).offset(10)
      make.bottom.equalTo(contentView).inset(16)
    }
    super.updateConstraints()
  }
  
  private func handleSlots(slots: [String: Bool]) {
    let availableSlots = slots.filter{ $0.value }
    if availableSlots.count > 0 {
      contentView.backgroundColor = .systemGreen
    } else {
      contentView.backgroundColor = .systemRed
    }
  }
}
