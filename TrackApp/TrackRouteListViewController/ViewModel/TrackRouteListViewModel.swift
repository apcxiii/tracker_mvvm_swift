//
//  TrackRouteListViewModel.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import Foundation

struct TrackRouteListViewModel {
  // MARK: - Properties
  let trackRoute: TrackRoute
  
  var name: String {
    if trackRoute.name.count == 0 {
      return "-"
    }else{
      return trackRoute.name
    }
    
  }
  
  var distance: String {
    let distanceMeasurement = Measurement(value: trackRoute.distance, unit: UnitLength.meters).converted(to: .kilometers)
    return FormatDisplay.distance(distanceMeasurement)
  }
  
  
  var timestamp: String {
    
    if trackRoute.timestamp != nil {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE, MMMM d"
      return formatter.string(from: trackRoute.timestamp! )
    }else{
      return "-"
    }
  }
}

extension TrackRouteListViewModel: RouteRepresentable {
  
}
