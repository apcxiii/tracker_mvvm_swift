//
//  UIImage+Extensions.swift
//  TrackApp
//
//  Created by Erik on 26/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import UIKit

extension UIImage {
  class func imageWithView(_ view: UIView) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false ,  UIScreen.main.scale)
    defer { UIGraphicsEndImageContext() }
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
}
