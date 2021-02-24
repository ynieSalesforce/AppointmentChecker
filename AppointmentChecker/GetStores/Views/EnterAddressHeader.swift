//
//  EnterAddressHeader.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/24/21.
//

import Foundation
import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift

class EnterAddressHeader: UIView {
  let addressObserver: Signal<String, Never>.Observer
  
  init(addressObserver: Signal<String, Never>.Observer) {
    self.addressObserver = addressObserver
    super.init(frame: .zero)
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  private lazy var addressTextfield: UITextField = {
    let textfield = UITextField()
    textfield.placeholder = "Please enter zipcode or city"
    textfield.returnKeyType = .search
    textfield.delegate = self
    addSubview(textfield)
    return textfield
  }()
  
  private lazy var enterButton: UIButton = {
    let button = UIButton()
    button.setTitle("Search", for: .normal)
    button.onTap {
      self.searchAddress()
    }
    addSubview(button)
    return button
  }()
  
  private lazy var label: UILabel = {
    let label = UILabel.init()
    label.text = "Useful feed"
    addSubview(label)
    return label
  }()
  
  override func updateConstraints() {
    addressTextfield.snp.updateConstraints { (make) in
      make.leading.top.bottom.equalTo(self).inset(16)
      make.height.equalTo(45)
    }
    enterButton.snp.updateConstraints { (make) in
      make.bottom.top.equalTo(addressTextfield)
      make.trailing.equalTo(self).inset(16)
      make.leading.equalTo(addressTextfield.snp.trailing).inset(16)
    }
    super.updateConstraints()
  }
  
  private func searchAddress() {
    guard let addressText = addressTextfield.text, !addressText.isEmpty else {
      return
    }
    addressObserver.send(value: addressText)
  }
}

extension EnterAddressHeader: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    self.searchAddress()
    return false
  }
}
