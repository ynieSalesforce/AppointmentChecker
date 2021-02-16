//
//  BaseViewController.swift
//  Trailhead
//
//  Created by Qingqing Liu on 3/12/19.
//  Copyright © 2019 Salesforce.com. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

/**
 BaseViewController is the base class for all view controllers
 which handles common task during ViewController lifecycle
 */

class BaseViewController: UIViewController {
  var dataLoaded = false {
    didSet {
      if dataLoaded {}
    }
  }

  let lifecycle = ViewLifeCycle()
  let refreshControl = UIRefreshControl.init()
  
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    .darkContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureUI()
    styleUI()
    bindViewModel()

    lifecycle.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
    updateNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    lifecycle.viewDidAppear()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    lifecycle.viewDidDisappear()
  }

  func updateNavigationBar() {
    guard let navigationController = self.navigationController else {
      return
    }
    let useLargeTitle = navigationController.viewControllers.first == self && presentingViewController == nil
    navigationController.navigationBar.prefersLargeTitles = useLargeTitle
    // only set navigation item title if useLargeTitle is true
    if useLargeTitle {
      navigationItem.title = navigationController.tabBarItem.title
      // W-6031082 - Fix issue with Refresh control and Large Titles
      // see: https://stackoverflow.com/questions/50708081/prefer-large-titles-and-refreshcontrol-not-working-well
      extendedLayoutIncludesOpaqueBars = true
    }
  }

  // child class to override
  func styleUI() {
    view.backgroundColor = .lightText
    guard let navigationController = self.navigationController else { return }

    // Replace iOS 13 transparent Navigation Bar with opague color
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()

    navBarAppearance.backgroundColor = .white
    navigationController.navigationBar.standardAppearance = navBarAppearance
    navigationController.navigationBar.compactAppearance = navBarAppearance
    navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance

    navigationController.navigationBar.barTintColor = .white

    // toolbar
    navigationController.toolbar.barTintColor = .white
  }

  // child class to override to setup UI
  func configureUI() {
    // do nothing
  }

  // child class to override to bind to view model
  func bindViewModel() {
    // do nothing
  }

  func makeFullScreen() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    edgesForExtendedLayout = .top
  }
}

internal extension Reactive where Base: BaseViewController {
  var dataLoadingError: BindingTarget<DataLoadingError> {
    makeBindingTarget { (vc: BaseViewController, error: DataLoadingError) in
      //Handle Error
    }
  }
}

extension BaseViewController: Reloadable {
  func reload() {
    refreshControl.sendActions(for: .valueChanged)
  }

  func isDataLoaded() -> Bool {
    dataLoaded
  }
}
