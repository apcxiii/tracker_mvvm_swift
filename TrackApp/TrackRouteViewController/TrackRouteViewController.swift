//
//  TrackRouteViewController.swift
//  TrackApp
//
//  Created by Erik on 25/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

class TrackRouteViewController: UIViewController {
  
  @IBOutlet weak var trackButton: UIButton!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  
  @IBOutlet weak var saveContainer: UIView!
  @IBOutlet weak var nameTextfield: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  
  
  private let locationManager = LocationManager.shared
  private var seconds = 0
  private var timer: Timer?
  private var distance = Measurement(value: 0, unit: UnitLength.meters).converted(to: .kilometers)
  private var locationList: [CLLocation] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }
  
  private func setupView() -> Void{
    self.view.backgroundColor = .gray
    self.trackButton.layer.cornerRadius = 8
    
    self.mapView.layer.cornerRadius = 8
    self.mapView.layer.borderColor = UIColor.black.cgColor
    self.mapView.layer.borderWidth = 3
    self.mapView.showsUserLocation = true
  }
  
  private func updateDisplay() -> Void{
    let formattedDistance = FormatDisplay.distance(distance)
    let formattedTime = FormatDisplay.time(seconds)
    let formattedPace = FormatDisplay.pace(distance: distance,
                                           seconds: seconds,
                                           outputUnit: UnitSpeed.minutesPerKilometer)
    self.distanceLabel.text = "Distance:  \(formattedDistance)"
    self.timeLabel.text = "Time:  \(formattedTime)"
    self.paceLabel.text = "Pace:  \(formattedPace)"
  }
  
  //MARK: - Timer
  func eachSecond() -> Void {
    self.seconds += 1
    self.updateDisplay()
  }
  
  /**
   Config for location Manager
   */
  private func startLocationUpdates() {
    
    if CLLocationManager.locationServicesEnabled() {
      self.locationManager.delegate = self
      self.locationManager.distanceFilter = 2
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
      self.locationManager.startUpdatingLocation()
    }
  }
  
  //MARK: - Tracking functions
  
  private func startRun() -> Void{
    self.trackButton.backgroundColor = .systemRed
    self.trackButton.setTitle("Stop", for: UIControl.State())
    
    self.mapView.removeOverlays(mapView.overlays)
    
    self.seconds = 0
    self.distance = Measurement(value: 0, unit: UnitLength.meters)
    self.updateDisplay()
    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
      self.eachSecond()
    })
    self.startLocationUpdates()
  }
  
  private func stopRun() {
    
    self.distanceLabel.text = "Distance:"
    self.timeLabel.text = "Time:"
    self.paceLabel.text = "Pace:"
    self.trackButton.backgroundColor = .systemGreen
    self.trackButton.setTitle("Start", for: UIControl.State())
    locationManager.stopUpdatingLocation()
    timer?.invalidate()
    self.saveRun()
    self.seconds = 0
  }
  
  private func saveRun() -> Void {
    let newRun = TrackRoute()
    newRun.active = true
    newRun.distance = distance.value
    newRun.duration = self.seconds
    newRun.timestamp = Date()
    
    
    for location in self.locationList {
      let locationObject = Location()
      locationObject.timestamp = location.timestamp
      locationObject.latitude = location.coordinate.latitude
      locationObject.longitude = location.coordinate.longitude
      newRun.locations.append(locationObject)
    }
    
    
    let realm = try! Realm(configuration: TrackAppRealm.config)
    try! realm.write {
      realm.create(TrackRoute.self,value: newRun,update: .error)
    }
    
    
    
  }
  // MARK: - Actions functions
  
  @IBAction func trackAction(_ sender: UIButton) {
    if seconds > 0{
      self.stopRun()
    }else{
      self.startRun()
    }
  }
}

extension TrackRouteViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else {
        continue
      }
      
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        self.distance = self.distance + Measurement(value: delta,
                                                    unit: UnitLength.meters)
        let coordinates = [lastLocation.coordinate, newLocation.coordinate]
        self.mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
        let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        self.mapView.setRegion(region, animated: true)
                
      }
      
      locationList.append(newLocation)
    }
  }
}

extension TrackRouteViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
     guard let polyline = overlay as? MKPolyline else {
         return MKOverlayRenderer(overlay: overlay)
       }
       let renderer = MKPolylineRenderer(polyline: polyline)
       renderer.strokeColor = .blue
       renderer.lineWidth = 3
       return renderer
  }
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    mapView.setCenter(userLocation.coordinate, animated: true)
  }
}
