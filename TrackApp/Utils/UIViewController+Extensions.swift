//
//  UIViewController+Extensions.swift
//  TrackApp
//
//  Created by Erik on 26/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import UIKit

extension UIViewController {
  func alert(_ title:String, message:String, dismiss:String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: dismiss, style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
  }
}
