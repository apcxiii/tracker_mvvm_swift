//
//  TrackAppRealm.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import Foundation
import RealmSwift

class TrackAppRealm {
  static var inMemory = false
  static var name = "0cmxdb.realm"
  fileprivate static var configuration:Realm.Configuration?
  
  static func _config()->Realm.Configuration {
    if inMemory {
      return Realm.Configuration(fileURL: nil, inMemoryIdentifier: "testConfig\(name)", encryptionKey: nil, readOnly: false, schemaVersion: 2, migrationBlock: { version, oldVersion in
        
      }, objectTypes: nil)
    } else {
      return Realm.Configuration.defaultConfiguration
    }
  }
  
  static var config:Realm.Configuration {
    if let configuration = configuration {
      return configuration
    } else {
      configuration = _config()
      return configuration!
    }
  }
}
