//
//  TrackDetailViewController.swift
//  TrackApp
//
//  Created by Erik on 26/11/19.
//  Copyright © 2019 Erik. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
class TrackDetailViewController: UIViewController {
  
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  @IBOutlet weak var shareButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  
  var backButton: UIBarButtonItem?
  
  
  // MARK: -
  var viewModel: TrackDetailViewViewModel? {
    didSet{
      self.viewDidLoad()
      self.updateView()
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    self.setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.loadMap()
  }
  
  
  private func setupView() -> Void {
    self.view.backgroundColor = .systemGray
    
    self.mapView.layer.cornerRadius = 8
    self.mapView.layer.borderColor = UIColor.black.cgColor
    self.mapView.layer.borderWidth = 3
    
    self.shareButton.layer.cornerRadius = 8
    self.shareButton.backgroundColor = .systemBlue
    self.shareButton.setTitle("Share", for: UIControl.State())
    
    self.deleteButton.layer.cornerRadius = 8
    self.deleteButton.backgroundColor = .systemRed
    self.deleteButton.setTitle("Delete", for: UIControl.State())
    
    self.backButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissView))
    self.navigationItem.leftBarButtonItem = self.backButton
    
    self.distanceLabel.textColor = .white
    self.distanceLabel.text = "Distance:"
    
    self.durationLabel.textColor = .white
    self.durationLabel.text = "Duration:"
  }
  
  private func updateView() {
    if let viewModel = viewModel {      
      self.updateDataView(withViewModel: viewModel)
    } else {
      debugPrint("Nothing to display")
    }
  }
  
  
  private func updateDataView(withViewModel viewModel: TrackDetailViewViewModel) {
    self.durationLabel.text = "Duration: \(viewModel.duration)"
    self.distanceLabel.text = "Distance: \(viewModel.distance) hrs"
  }
  
  
  //MARK: - delete action
  
  @IBAction func deleteRoute(_ sender: UIButton) -> Void {
    let realm = try! Realm(configuration: TrackAppRealm.config)
    try! realm.write {
      realm.delete((self.viewModel?.trackRoute)!)
      self.dismissView()
    }
  }
  @IBAction func shareAction(_ sender: UIButton) -> Void {
    let image: UIImage = UIImage.imageWithView(self.mapView)
    var sharedObjects = [AnyObject]()
    
    sharedObjects.append(image as AnyObject)
    //sharedObjects.append("Sharing" as AnyObject)
    let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.mail]
    
    activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
      
      if activityError != nil {
        self.alert("", message: activityError!.localizedDescription, dismiss: "Ok")
      }
      if !completed {
        return
      }
      
      
      
    }
    self.present(activityViewController, animated: true, completion: nil)
  }
  
  //MARK:- map functions
  
  private func loadMap() {
    guard
      let locations = viewModel?.trackRoute.locations,
      locations.count > 0,
      let region = mapRegion()
    else {
      let alert = UIAlertController(title: "Error",
                                    message: "Sorry, this run has no locations saved",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel))
      present(alert, animated: true)
      return
    }
    
    let firsAnnotation = CustomAnnotation(typeRef: "START")
    firsAnnotation.coordinate = CLLocationCoordinate2D(latitude: locations.first?.latitude ?? 0.0,
                                                       longitude: locations.first?.longitude ?? 0.0)
    firsAnnotation.title = "START"
    
    mapView.addAnnotation(firsAnnotation)
    
    let lastAnnotation = CustomAnnotation(typeRef: "FINISH")
    
    lastAnnotation.coordinate = CLLocationCoordinate2D(latitude: locations.last?.latitude ?? 0.0,
                                                       longitude: locations.last?.longitude ?? 0.0)
    lastAnnotation.title = "FINISH"
    mapView.addAnnotation(lastAnnotation)
    mapView.setRegion(region, animated: true)
    mapView.addOverlays(polyLine())
  }
  
  
  
  
  
  private func polyLine() -> [MulticolorPolyline] {
    
    // 1
    let locations = viewModel?.trackRoute.locations
    var coordinates: [(CLLocation, CLLocation)] = []
    var speeds: [Double] = []
    var minSpeed = Double.greatestFiniteMagnitude
    var maxSpeed = 0.0
    
    // 2
    for (first, second) in zip(locations!, locations!.dropFirst()) {
      let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
      let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
      coordinates.append((start, end))
      
      //3
      let distance = end.distance(from: start)
      let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
      let speed = time > 0 ? distance / time : 0
      speeds.append(speed)
      minSpeed = min(minSpeed, speed)
      maxSpeed = max(maxSpeed, speed)
    }
    
    //4
    let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
    
    //5
    var segments: [MulticolorPolyline] = []
    for ((start, end), speed) in zip(coordinates, speeds) {
      let coords = [start.coordinate, end.coordinate]
      let segment = MulticolorPolyline(coordinates: coords, count: 2)
      segment.color = segmentColor(speed: speed,
                                   midSpeed: midSpeed,
                                   slowestSpeed: minSpeed,
                                   fastestSpeed: maxSpeed)
      segments.append(segment)
    }
    return segments
  }
  
  private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
    enum BaseColors {
      static let r_red: CGFloat = 1
      static let r_green: CGFloat = 20 / 255
      static let r_blue: CGFloat = 44 / 255
      
      static let y_red: CGFloat = 1
      static let y_green: CGFloat = 215 / 255
      static let y_blue: CGFloat = 0
      
      static let g_red: CGFloat = 0
      static let g_green: CGFloat = 146 / 255
      static let g_blue: CGFloat = 78 / 255
    }
    
    let red, green, blue: CGFloat
    
    if speed < midSpeed {
      let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
      red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
      green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
      blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
    } else {
      let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
      red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
      green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
      blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
    }
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }
  
  private func mapRegion() -> MKCoordinateRegion? {
    guard
      let locations = viewModel?.trackRoute.locations,
      locations.count > 0
      else {
        return nil
    }
    
    let latitudes = locations.map { location -> Double in
      return location.latitude
    }
    
    let longitudes = locations.map { location -> Double in
      return location.longitude
    }
    
    let maxLat = latitudes.max()!
    let minLat = latitudes.min()!
    let maxLong = longitudes.max()!
    let minLong = longitudes.min()!
    
    let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                        longitude: (minLong + maxLong) / 2)
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                longitudeDelta: (maxLong - minLong) * 1.3)
    return MKCoordinateRegion(center: center, span: span)
  }
  
  @objc func dismissView() -> Void {
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension TrackDetailViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MulticolorPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = polyline.color
    renderer.lineWidth = 3
    return renderer
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }

    let identifier = "Annotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

    if annotationView == nil {
      
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        
      annotationView?.canShowCallout = true
    } else {
        annotationView!.annotation = annotation
    }
    
    if let annotation = annotation as? CustomAnnotation {
      if annotation.type == "START" {
        let startId = "kSTART"
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: startId)
        annotationView?.image = UIImage(named: "first")
        annotationView?.canShowCallout = true
      }else{
        let finishId = "kFINISH"
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: finishId)
        annotationView?.image = UIImage(named: "second")
        annotationView?.canShowCallout = true
      }
    }

    return annotationView
  }
  
  
}
