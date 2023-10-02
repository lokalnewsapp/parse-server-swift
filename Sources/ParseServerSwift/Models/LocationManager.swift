////
////  LocationManager.swift
////  Lokality
////
////  Created by Jayson Ng on 11/18/21.
////
//
//import Foundation
//import CoreLocation
//import os.log
//import ParseSwift
//
//final class LocationManager: NSObject, ObservableObject {
//
//  var locationManager = CLLocationManager()
//
//  @Published var locations: [CLLocation]?
//  @Published var currentDeviceCoordinate: CLLocationCoordinate2D?
//
//  override init() {
//    super.init()
//    locationManager.delegate = self
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest
////    locationManager.desiredAccuracy = kCLLocationAccuracyReduced
//    locationManager.distanceFilter  = 500.0
//
//    // We don't need background updates.
//    locationManager.allowsBackgroundLocationUpdates = false
//  }
//
////  func startLocationServices() {
////    print("\n\n starting location services... \n\n")
////    if locationManager.authorizationStatus == .authorizedAlways ||
////        locationManager.authorizationStatus == .authorizedWhenInUse {
////      locationManager.startUpdatingLocation()
////    } else {
////      locationManager.requestWhenInUseAuthorization()
////    }
////  }
//}
//
//// MARK: - -------------- Methods Needed to get Device Location ---------------
//extension LocationManager: CLLocationManagerDelegate {
//
//  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//    if locationManager.authorizationStatus == .authorizedAlways ||
//        locationManager.authorizationStatus == .authorizedWhenInUse {
//      locationManager.startUpdatingLocation()
//    }
//  }
//
//  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//    guard let clError = error as? CLError else { return }
//
//    switch clError {
//    case CLError.denied:
//      Logger.location.error("Access Denied")
//    default:
//        Logger.location.error("\(LOKError(.failedToGetLocation))")
//    }
//    Logger.location.error("func locationManager \(error.localizedDescription)")
//  }
//
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    guard let location = locations.first else {
//        Logger.location.error("locationManager: \(LOKError(.noDeviceCoordinate))")
//      return
//    }
//    self.locations = locations
//    self.currentDeviceCoordinate = location.coordinate
//  }
//}
