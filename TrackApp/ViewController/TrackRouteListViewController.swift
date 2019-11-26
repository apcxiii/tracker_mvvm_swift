//
//  TrackRouteListViewController.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import UIKit

class TrackRouteListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    
  }
  
  
  private func setupView() -> Void {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.tableFooterView = UIView()
    self.tableView.register(UINib(nibName: "RouteCell", bundle: nil), forCellReuseIdentifier: "kRouteCell")
  }
  
}

extension TrackRouteListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
}


extension TrackRouteListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let results = TrackRoute.obtainActiveRoutesSortedByDate()
    return results == nil ? 0 : results!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "kRouteCell") as? RouteCell else {
      fatalError("Unexpected Table View Cell")
    }
    var viewModel: RouteRepresentable?
    let results = TrackRoute.obtainActiveRoutesSortedByDate()
    
    guard let routeModel = results?[indexPath.row] else{
      fatalError("Unexpected Index Path")
    }
    
    viewModel = TrackRouteListViewModel(trackRoute: routeModel)
    if let  viewModel = viewModel {
      cell.configure(withModel: viewModel)
    }
    return cell
  }
  
  
}
