//
//  TrackRoute.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import Foundation
import RealmSwift

class TrackRoute: Object {
  @objc dynamic var distance: Double = 0.0
  @objc dynamic var duration: Int = 0
  @objc dynamic var timestamp: Date? = nil
  @objc dynamic var active: Bool = false
  var locations = List<Location>()
}
