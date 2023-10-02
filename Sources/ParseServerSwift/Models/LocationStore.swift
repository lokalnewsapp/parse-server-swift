//
//  LocationStore.swift
//  Lokality
//
//  Created by Jayson Ng on 6/10/21.
//

import Foundation
import CoreLocation
import SwiftUI
import ParseSwift
import MapKit
import Countries
import os.log
import Vapor

class LocationStore: ObservableObject {

//    enum LocationStoreState {
//        case isIdle
//        case isLoaded
//    }
//
//    @Published var state: LocationStoreState            = .isIdle
    @Published var defaultLokality: Location?
    @Published var currentLokalityObject: Lokality?
    @Published var currentLocationObject: Location?

    var currentLocation: Location? {
        get { currentLocationObject }
        set { currentLocationObject = newValue }
    }

//    var region: MKCoordinateRegion {
//        let center = CLLocationCoordinate2D(latitude: currentDeviceCoordinate?.latitude ?? 0.0,
//                                            longitude: currentDeviceCoordinate?.longitude ?? 0.0)
//        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//
//        return MKCoordinateRegion(center: center, span: span)
//    }

    // MARK: - --------------  Search Results Properties  ---------------
    @Published var favoriteLocations: Locations?
    @Published var nearYou: [Location] = []
    @Published var searchResults: [Location]?
    @Published var searchResultsClPlacemark: [CLPlacemark?]?
    @Published var searchResultsNearYouClPlacemark: [CLPlacemark?]?

    // MARK: - --------------  CLLocation Properties  ---------------
    //var locationManager: LocationManager  = LocationManager()
    lazy var geocoder                     = CLGeocoder()

    //    private var originalLocationController: LocationController?
    // public static var currentDeviceCoordinate: CLLocationCoordinate2D?
//    var currentDeviceCoordinate: CLLocationCoordinate2D? {
//        locationManager.currentDeviceCoordinate
//    }

    // MARK: - --------------  Location Request Methods  ---------------
//    func getCurrentLocation() async throws {
//        return try await startUp()
//    }

    // Run after getting the device location back.
//    func startUp() async throws {
//
//        locationManager.startLocationServices()
//
//        // 1. Fetch Location data from CLPlacemark
//        // - We get the device location (coordinate) here
//        // - We also get Lokality Location here
//        if let clLocation = locationManager.locations?.first {
//            do {
//                var clPlacemark = try await getClPlacemark(clLocation: clLocation)
//                printPlacemarkInfo(clPlacemark)
//                clPlacemark = try await processClPlacemark(clPlacemark)
//
//                do {
//                    if let currentLocation = try await getLocation(byCLPlacemark: clPlacemark) {
//                        //Logger().info("LocationController: \(currentLocation.name ?? "")")
//
//                        DispatchQueue.main.async {
//                            // Set the currentLocation property
//                            self.currentLocation = currentLocation
//                            //Logger.location.info("currentLokality = \(self.currentLocation?.name ?? "")")
//                        }
//                    }
//                } catch {
//                    // There's no Location found - create a new Location
//                    let location = try await createLocationObjects(for: clPlacemark)
//                    DispatchQueue.main.async {
//                        self.currentLocation = location
//                    }
//                }
//            } catch let error as LokalityError {
//                //Logger.location.info("Error creating Location: \(error.code.description)")
//                throw LOKError(.failedToCreateLocation)
//            }
//        } else {
////            Logger.location.info("Failed to get device location")
//            throw LOKError(.failedToGetLocation)
//        }
//    }

    func getClPlacemark(clLocation: CLLocation) async throws -> CLPlacemark {
        do {
            let result = try await geocoder.reverseGeocodeLocation(clLocation)
            if let clPlacemark = result.first {
                return clPlacemark
            } else {
                throw LOKError(.noPlacemark)
            }
        } catch let error as ParseError {
            throw error
        } catch {
            throw LOKError(.failedToGetCLPlacemark, message: error.localizedDescription)
        }
    }
}

// MARK: - -------------- Get Location Methods ---------------
extension LocationStore {
    func getLocation(byCLPlacemark placemark: CLPlacemark) async throws -> Location? {
        do {
            let locationPlacemark =  try await getLocationPlacemark(for: placemark)
            let location = try await getLocation(byPlacemark: locationPlacemark)
            return location
        } catch let error as LokalityError {
            throw error
        }
    }

    func getLocation(byPlacemark placemark: LocationPlacemark) async throws -> Location {

        let inQuery = try LocationDetails.query("placemark" == placemark).includeAll()
        let query = Location.query("details" == inQuery).where("active" == true).includeAll()

        do {
            return try await query.first()
        } catch let error as ParseError {
//            Logger.location.error("Error: getLocation(by location placemark): \(error.description)")
            throw LOKError(.parseError(error))
        }
    }

   

    // TODO: getLocation by maintag
    func getLocation(byMainTagString mainTagString: String) async throws -> Location {
        do {
            let inQuery = LocationDetails.query("mainTagString" == mainTagString).includeAll()
            let query = Location.query("details" == inQuery).where("active" == true).includeAll()
            return try await query.first()
        } catch let error as ParseError {
//            Logger.location.error("Error: getLocation(byMainTagString): \(error.description)")
            throw LOKError(.parseError(error))
        }
    }

}

// MARK: - -------------- Create Location(s) Methods ---------------
extension LocationStore {
    func getOrCreateLocation(
        with placemark: LocationPlacemark,
        placemarkLevel: PlacemarkLevel,
        parent: Location? = nil
    ) async throws -> Location {
        do {
            return try await getLocation(byPlacemark: placemark)
            //
            //            // We found a location object.
            //            return locationController.location

        } catch {
            // There is no location.
            // We need to create a new location here based on existing LocationPlacemark
            do {

                let location = try await createLocation(for: placemark, placemarkLevel: placemarkLevel, parent: parent)
                return location

            } catch let error as LokalityError {
//                Logger.location.info("Failed to create location: \(error.code.description)")
                throw LOKError(.failedToCreateLocation)
            }
        }
    }

}

// MARK: - --------------  Location Placemark Methods ---------------
extension LocationStore {
    func getOrCreateLocationPlacemark(with placemark: CLPlacemark, address: String) async throws -> LocationPlacemark {
        do {
            let locationPlacemark       = try await getLocationPlacemark(for: placemark)
            return locationPlacemark
        } catch {
            do {
                let locationPlacemark =  try await createLocationPlacemark(for: placemark, address: address)
                //                Logger.location.info("Success creating locationPlacemark \(locationPlacemark.name)")
                return locationPlacemark
            } catch {
                throw LOKError(.failedToCreateLocationPlacemark)
            }
        }
    }

    func createLocationPlacemark(for placemark: CLPlacemark, address: String, name: String? = nil) async throws -> LocationPlacemark {

        if let latitude = placemark.location?.coordinate.latitude,
           let longitude = placemark.location?.coordinate.longitude {

            let center = try ParseGeoPoint(latitude: latitude, longitude: longitude)
            var locationPlacemark = LocationPlacemark()
            locationPlacemark.address                   = address
            locationPlacemark.center                    = center
            locationPlacemark.radius                    = 1.0 // placemark.region

            if let name = name {
                locationPlacemark.name                      = name
            } else {
                locationPlacemark.name                      = placemark.name ?? ""
            }

            locationPlacemark.thoroughfare              = placemark.thoroughfare
            locationPlacemark.subLocality               = placemark.subLocality
            locationPlacemark.locality                  = placemark.locality
            locationPlacemark.subAdministrativeArea     = placemark.subAdministrativeArea
            locationPlacemark.administrativeArea        = placemark.administrativeArea
            locationPlacemark.country                   = placemark.country
            locationPlacemark.isoCountryCode            = placemark.isoCountryCode
            locationPlacemark.areasOfInterest           = placemark.areasOfInterest

            return try await locationPlacemark.save()
        }

        throw LOKError(.failedToCreateLocationPlacemark)
    }

    func getLocationPlacemark(name: String, center: ParseGeoPoint) async throws -> LocationPlacemark {
        var query: Query<LocationPlacemark>
        var constraints = [QueryConstraint]()

        do {
            // Add Constraints
            constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: center, distance: 1.5))
            let query1 = LocationPlacemark.query(constraints)
            let query2 = LocationPlacemark.query("name" == name)
            // Run the query
            query = LocationPlacemark.query(and(queries: [query1, query2]))

            let locationPlacemark = try await query.first()

            if locationPlacemark.objectId != nil {
//                Logger.location.info("Address is: \(locationPlacemark.address ?? "")")
                return locationPlacemark
            } else {
                throw LOKError(.noPlacemark)
            }

        } catch let error as ParseError {
//            Logger.location.error("Error: \(error.description)")
            throw LOKError(.noPlacemark)
        } catch {
            throw LOKError(.noPlacemark)
        }
    }

    func getLocationPlacemark(for placemark: CLPlacemark) async throws -> LocationPlacemark {
        var query: Query<LocationPlacemark>
        var constraints = [QueryConstraint]()
        var pointToFind: ParseGeoPoint

        if let clLocation = placemark.location {
            do {
                pointToFind = try ParseGeoPoint(location: clLocation)

                // Add Constraints
                // 1. near geopoint
                // 2. matching name field
                constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: pointToFind, distance: 1.5))
                let query1 = LocationPlacemark.query(constraints)
                let query2 = LocationPlacemark.query("name" == placemark.name)
                // Run the query
                query = LocationPlacemark.query(and(queries: [query1, query2]))

                let locationPlacemark = try await query.first()

                if locationPlacemark.objectId != nil {
//                    Logger.location.info("Address is: \(locationPlacemark.address ?? "")")
                    return locationPlacemark
                }

            } catch let error as ParseError {
//                Logger.location.error("Error: \(error.description)")
                throw LOKError(.noPlacemark)
            }
        }
        throw LOKError(.noPlacemark)
    }
}

// MARK: - -------------- Search Methods ---------------
extension LocationStore {

//    func getNearYouClPlacemark() async throws {
//        if let latitude = currentDeviceCoordinate?.latitude,
//           let longitude = currentDeviceCoordinate?.longitude {
//            do {
//                // let result = try await geocoder.geocodeAddressString(locationName.wrappedValue)
//                let result = try await geocoder.reverseGeocodeLocation(
//                    CLLocation(latitude: latitude, longitude: longitude), preferredLocale: Locale.current
//                )
//
//                DispatchQueue.main.async {
//                    self.searchResultsNearYouClPlacemark = result
//                }
//
//            } catch let error as ParseError {
////                Logger.location.info("\(LOKError(.failedToGetCLPlacemark)): error \(error.localizedDescription)")
//
//                throw LOKError(code: .failedToGetCLPlacemark, message: "\(error.description)")
//            }
//        }
//    }

    /// Search location by name and saves result to self.searchResults if there's any
    /// - Parameter locationName: locationName description
    /// - Returns: True or False if success
    func searchLocation(name locationName: Binding<String>) async throws -> Bool {
        do {
            let result = try await geocoder.geocodeAddressString(locationName.wrappedValue)
            DispatchQueue.main.async {
                self.searchResultsClPlacemark = result
            }
        } catch {
//            Logger.location.info("\(LOKError.Code.failedToGetCLPlacemark): error \(error.localizedDescription)")
        }

        // https://stackoverflow.com/a/35209613
        // TODO: Sort by distance from user?
        // TODO: Fix for LocationDetails and use createLocationNameConstraints

        // Clean up search string
        let searchString = locationName.wrappedValue.trimmed()

        // We constrain the search to name, altNames, and mainTagString fields
        let constraints = matchesRegex(key: "name", regex: searchString)
        let query1 = LocationDetails.query(constraints)
        let constraints2 = matchesRegex(key: "altNames", regex: searchString, modifiers: "i")
        let query2 = LocationDetails.query(constraints2)
        let constraints3 = matchesRegex(key: "mainTagString", regex: searchString.replacingOccurrences(of: " ", with: ""), modifiers: "i")
        let query3 = LocationDetails.query(constraints3)
        let inQuery = LocationDetails.query(or(queries: [query1, query2, query3])).includeAll()

        let query = Location.query("details" == inQuery)
            .where("active" == true)
            .includeAll()

        do {
            let foundLocations = try await query.limit(10).includeAll().find()
            dump("Number of found locations: \(foundLocations.count)")
            DispatchQueue.main.async {
                self.searchResults  = foundLocations
            }
            return true

        } catch {
            //Logger.info("\(error.localizedDescription)")
            throw LOKError(.searchLocationFailed)
        }
    }

    /// Get Locations Near You
    /// - Returns: True or False if getting the location was successful
//    func getLocationsNearYou() async throws -> Bool {
//        let geoPoint = try ParseGeoPoint(latitude: currentDeviceCoordinate?.latitude ?? 0.0,
//                                         longitude: currentDeviceCoordinate?.longitude ?? 0.0)
//        var constraints = [QueryConstraint]()
//        constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: geoPoint, distance: 1.5))
//        let inQuery = LocationDetails.query(constraints)
//        let query = Location.query().where("details" == inQuery, "active" == true)
//
//        do {
//            let foundLocations = try await query.limit(50).includeAll().find()
//            //            let locationControllers = foundLocations.map { LocationController(with: $0) }
//            DispatchQueue.main.async {
//                self.nearYou  = foundLocations
//            }
//            return true
//        } catch {
//            //Logger.location.error("\(error.localizedDescription)")
//            throw LOKError(.searchLocationFailed)
//        }
//    }

    /// Get Child Locations
    /// - Parameter location: Location Object to get related children of.
    /// - Returns: Array of children LocationControllers based on parent object.
    func getChildLocations(for location: Location) async throws -> [Location?]? {
        if let details = location.details {
            let locationPointer = try details.toPointer()
            let query = Location.query().where("parentDetails" == locationPointer, "active" == true)

            do {
                return try await query.limit(20).includeAll().find()
                //                let foundLocations = try await query.limit(20).includeAll().find()
                //                let locationControllers = foundLocations.map { LocationController(with: $0) }
                //                return locationControllers
            } catch {
                //Logger.location.error("\(error.localizedDescription)")
                throw LOKError(.failedToGetLocation)
            }
        } else {
            throw LOKError(.failedToGetLocation)
        }
    }
}

