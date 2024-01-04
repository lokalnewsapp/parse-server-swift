//
//  LocationStore+CreateLocaation.swift
//  Lokality
//
//  Created by Jayson Ng on 11/20/21.
//

import Foundation
import ParseSwift
import CoreLocation
// import os.log

extension LocationStore {

    /// Create Location objects for the given CLPlacemark
    /// - Parameter clPlacemark: CLPlacemark object from device location
    /// - Returns: The current location's Location object
    func createLocationObjects(for clPlacemark: CLPlacemark) async throws -> Location {
        var currentLocation: Location?
        var includeName: Bool = true

        // 1. Let's see if we want to include the .name level
        includeName = verifyPlacemarkName(clPlacemark, countryCode: clPlacemark.isoCountryCode ?? "PH")

        // 2. Cycle through each level of the CLPlacemarks that we care about
        for currentPlacemarkLevel in PlacemarkLevel.allCases.reversed() {
            var workingPlacemark: CLPlacemark?

            if currentPlacemarkLevel == .name && includeName == false {
                // Do nothing if includeName is false and we're at .name level
            } else {
                // Build the address of the clPlacemark level we're working with right now.
                let address = buildAddress(for: clPlacemark, startPlacemarkLevel: currentPlacemarkLevel)
                guard address != "" else {
                    //Logger.location.info("No Address for \(currentPlacemarkLevel).");
                    continue }

                // Setup placemark Array.
                // If it's name level, we just pass the original clPlacemark
                if currentPlacemarkLevel == .name {
                    workingPlacemark = clPlacemark
                } else {
                    // We have to call geocoder for the correct clPlacemark for that level.
                    do {
                        let clPlacemarkResult = try await geocoder.geocodeAddressString(address)
                        if let clPlacemark = clPlacemarkResult.first {
                            //Logger.location.info("clplacemark: \(clPlacemark)")
                            workingPlacemark = clPlacemark
                        }
                    } catch {
                        //Logger.location.error("creating clplacemark error: \(error.localizedDescription)")
                    }
                }

                // Only continue if we have a working placemark
                if workingPlacemark != nil {
                    do {
                        // Get LocationPlacemark Object from this clPlacemark
                        if let workingPlacemark = workingPlacemark {

                            printPlacemarkInfo(workingPlacemark, address: address)

                            // Get or Create the LocationPlacemark object
                            let locationPlacemark = try await getOrCreateLocationPlacemark(with: workingPlacemark, address: address)

                            // Get or Create the Location Object based on the LocationPlacemark
                            let location = try await getOrCreateLocation(
                                with: locationPlacemark,
                                placemarkLevel: currentPlacemarkLevel,
                                parent: currentLocation)

                            // Set the currentLocation object to the found location
                            currentLocation           = location
                        }

                    } catch {
                        throw LOKError(.failedToCreateLocation)
                    }
                } else {
                    print("Error: \(LokalityError.Code.failedToGetCLPlacemark)")
                }
            }

        } // end for loop

        // After all that processing
        // We return the last location created or nil if there's none.
        if let currentLocation = currentLocation {
            return currentLocation
        } else {
            throw LOKError(.failedToGetLocation)
        }
    }

//    func createLocation(name: String, tag: String, areaType: LocationAreaType) async throws -> Location {
//
//        //: 1. Get currentLocation
//        do {
//            try await self.getCurrentLocation()
//        } catch {
//            throw LOKError(.failedToGetLocation)
//        }
//
//        //: 2. Get current device location
//        do {
//            //: 2a. GetLocation based on given name if available
//            if let coordinate = self.currentDeviceCoordinate {
//                let location = try await getLocation(byName: name, andCenter: ParseGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
//
//                print("\n\n Found: \(location.name) tag: \(location.details?.mainTag) \n\n")
//
//                return location
//
//            } else {
//                throw LOKError(.failedToGetLocation, message: "No device coordinates available.")
//            }
//
//        } catch {
//
//            // No Location found by name and center.
//            // Let's create one.
//            if let coordinate = self.currentDeviceCoordinate {
//
//                let clLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//
//                let clPlacemark = try await getClPlacemark(clLocation: clLocation)
//
//                let parentLocation = self.currentLocation
//
//                let address = buildAddress(for: clPlacemark, startPlacemarkLevel: .name, name: name)
//
//                print("\n\n Address of new location is: \(address) parentLocation: \(parentLocation?.fullName)\n\n")
//
//                let locationPlacemark = try await createLocationPlacemark(for: clPlacemark, address: address, name: name)
//
//                let newLocation = try await createLocation(for: locationPlacemark, placemarkLevel: .name, parent: parentLocation)
//
//                print("\n\n Should be name: \(name) tag: \(tag) \n\n")
//                print("\n\n Details name: \(newLocation.details?.name) tag: \(newLocation.details?.mainTagString) \n\n")
//
//                var foundLocationDetails = newLocation.details ?? LocationDetails()
//                print("\n\n foundLocationDetails: \(foundLocationDetails.objectId) \n\n")
//
//                foundLocationDetails.name = name
//                foundLocationDetails.mainTagString = tag
//                foundLocationDetails.areaType = areaType
//
//                let saved = try await foundLocationDetails.save()
//                print("\n\n newname: \(saved.name) tag: \(saved.mainTagString) \n\n")
//
//                return newLocation
//
//            } else {
//                throw error
//            }
//        }
//    }

    /// Create Location Object
    /// - Parameters:
    ///   - placemark: LocationPlacemark object to base information on
    ///   - placemarkLevel: the PlacemarkLevel the current location is that we're processing
    ///   - parent: the parent Location of this object
    /// - Returns: new Location object
    func createLocation(
        for placemark: LocationPlacemark,
        placemarkLevel: PlacemarkLevel,
        parent: Location?
    ) async throws -> Location {

        // Setup Location Details
        var details = LocationDetails(newLocation: true, locationPlacemark: placemark)

        // MARK: - --------------  AreaType  ---------------
        // 1. get areaType defaults by country
        var locationAreaType: LocationAreaType?
        if let countryCode = placemark.isoCountryCode {
            if let locationAreaTypeByCountry = LocationAreaTypeByCountry.forCountry(countryCode) {
                locationAreaType = locationAreaTypeByCountry.getProperty(for: placemarkLevel)
                details.areaType = findAreaType(for: locationAreaType, placemark: placemark, placemarkLevel: placemarkLevel)
            } else {
                //Logger.location.info("That country is not in our LocationAreaTypeByCountry system.")
            }
        }

        // MARK: - --------------  Prefix & AltNames  ---------------
        // Do we need Suffix too?
        if let prefix = details.areaType?.prefix, let name = details.name {
            details.altNames?.append(prefix + " " + name)
        }

        // MARK: - --------------  MainTag  ---------------
        details.mainTagString = getTag(from: placemark.name ?? "", areaType: details.areaType)

        // MARK: - --------------  Save Location Details object  ---------------
        do {
            print("Trying to save new location details for \(details.name ?? "no name!")")
            let savedLocationDetails = try await details.save()
            assert(savedLocationDetails.objectId != nil)
            assert(savedLocationDetails.createdAt != nil)
            assert(savedLocationDetails.updatedAt != nil)
            // assert(savedLocationDetails.ACL == nil)
            print("=-=-=-=-=-=-=-=-=-=-")
            print("NEW OBJECT SAVED: \(String(describing: savedLocationDetails.name))")
            print("=-=-=-=-=-=-=-=-=-=-")

            //Logger.location.info("Done saving \(String(describing: savedLocationDetails.name))")
            // return savedLocation
            details = savedLocationDetails

            // MARK: - --------------  CREATE NEW LOCATION OBJECT  ---------------
            return try await createLocationHelper(with: details, parent: parent, placemarkLevel: placemarkLevel)

        } catch let error as ParseError {
            throw error
        }
    }
}

// MARK: - --------------  Create Location Helpers  ---------------
extension LocationStore {

    /// Helper for creating Location object
    /// - Parameters:
    ///   - locationDetails: locationDetails object
    ///   - parent: locationDetails object for the parent
    ///   - placemarkLevel: placemark level we're looking into.
    /// - Returns: New Location object.
    private func createLocationHelper(
        with locationDetails: LocationDetails,
        parent: Location?,
        placemarkLevel: PlacemarkLevel
    ) async throws -> Location {

        var newLocation = Location(details: locationDetails)

        // Assign values to these for now while we figure things out.
        // These are for reference only and should NOT be used for query.
        // Edit: now computed values. Should still work.
        // newLocation.fullName      = newLocation.name
        // newLocation.tag           = newLocation.details?.tag

        // MARK: - --------------  Parent  ---------------
        if let parentDetails = parent?.details {
            newLocation.parentDetails   = parentDetails
        } else if placemarkLevel == .country {
            let parentDetails = LocationDetails(world: true)
            newLocation.parentDetails   = parentDetails
        }

        // MARK: - --------------  isActive  ---------------
        newLocation.active                  = true

        // Actually Save the Location Object
        do {
            let savedLocation = try await newLocation.save()
            assert(savedLocation.objectId != nil)
            assert(savedLocation.createdAt != nil)
            assert(savedLocation.updatedAt != nil)
            print("=-=-=-=-=-=-=-=-=-=-")
            print("NEW OBJECT SAVED: \(String(describing: savedLocation.name))")
            print("=-=-=-=-=-=-=-=-=-=-")
            return savedLocation
        } catch {
            //Logger.location.info("Failed to save new location")
            throw LOKError(.failedToCreateLocation)
        }
    }

    /// Find the areaType of the given LocationPlacemark object
    /// - Parameters:
    ///   - locationAreaType: LocationAreaType object
    ///   - placemark: LocationPlacemark object to look into
    ///   - placemarkLevel: placemarkLevel
    /// - Returns: LocationAreaType
    func findAreaType(
        for locationAreaType: LocationAreaType?,
        placemark: LocationPlacemark,
        placemarkLevel: PlacemarkLevel
    ) -> LocationAreaType? {
        if locationAreaType?.objectId != nil {
            return locationAreaType
        } else if placemarkLevel == .country {
            // It's a country
            return LocationAreaType(type: .country)

        } else if placemark.name == placemark.thoroughfare {
            // It's a street!
            return LocationAreaType(type: .street)

        } else {
            // Let's see if we can match the locationAreaType by using the name
            if let placemarkName = placemark.name {
                for areaType in LocationAreaType.types {
                    if let label = areaType.label {
                        if placemarkName.contains(label) {
                            // return LocationAreaType(objectId: areaType.objectId!)
                            return areaType
                        } else if let altNames = areaType.altNames {
                            if altNames.contains(where: placemarkName.contains) {
                                return LocationAreaType(objectId: areaType.objectId!)
                            }
                        }
                    }
                }
            }
        }
        return nil
    }

    func getTag(from name: String, areaType: LocationAreaType?) -> String {
        var tag = name.lowercased()
            .trimmed()
            .trimmingCharacters(in: .illegalCharacters)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        // If it's a barangay, let's add prefix to mainTagString
        if let areaTypeName = areaType?.name {
            if areaTypeName == "brgy" {
                tag = "brgy" + tag
            }
        }
        return tag
    }

}

// MARK: - --------------  CLLocation Extension  ---------------
// TODO: Delete this
// Use ParseGeoPoint(location: ) instead.
// extension CLLocation {
//    func toGeoPoint() -> ParseGeoPoint {
//        var geopoint = ParseGeoPoint()
//        geopoint.latitude = coordinate.latitude
//        geopoint.longitude = coordinate.longitude
//        return geopoint
//    }
// }
