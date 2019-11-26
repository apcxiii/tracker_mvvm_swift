//
//  Location.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
  @objc dynamic var latitude: Double = 0.0
  @objc dynamic var longitude: Double = 0.0
  @objc dynamic var timestamp: Date? = nil
}
