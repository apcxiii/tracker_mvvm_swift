//
//  AppDelegate+Setup.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import Foundation
import RealmSwift

extension AppDelegate {
  
  /**
   Function to setup realm context
   */
  func setupRealm() -> Void {
    let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
      if oldSchemaVersion < 1 {
       //init
      }
      
      if oldSchemaVersion < 2 {
       //add active to TrackRoute model
      }
    }
    Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 2, migrationBlock: migrationBlock)
    let _ = try! Realm(configuration: TrackAppRealm.config)
  }
  
  /**
   Funct to steup location manager as singleton
   */
  func setupLocationManager() -> Void {
    let locationManager = LocationManager.shared
    locationManager.requestWhenInUseAuthorization()
    
  }
}
