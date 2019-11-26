//
//  CustomAnnotation.swift
//  TrackApp
//
//  Created by Erik on 26/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation:  MKPointAnnotation {
  var type: String
  
  init(typeRef: String) {
    self.type = typeRef
  }
  
}
