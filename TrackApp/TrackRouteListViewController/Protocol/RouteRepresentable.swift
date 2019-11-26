//
//  RouteRepresentable.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import Foundation

protocol RouteRepresentable {
  var name: String { get }
  var timestamp: String { get }
  var distance: String { get }
}
