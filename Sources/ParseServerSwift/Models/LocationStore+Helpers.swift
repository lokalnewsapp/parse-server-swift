//
//  LocationStore+Helpers.swift
//  Lokality
//
//  Created by Jayson Ng on 11/22/21.
//

import Foundation
import ParseSwift
import os.log
import CoreLocation
import Countries

// MARK: - -------------- Helper Methods ---------------
extension LocationStore {

    /// Process the placemark to remove any unwanted duplication
    /// - Parameter clPlacemark: clPlacemark to process
    /// - Returns: Processed / Fixed CLPlacemark object that we can use.
    func processClPlacemark(_ clPlacemark: CLPlacemark) async throws -> CLPlacemark {

        //: Check CLPlacemark Name field
        if verifyPlacemarkName(clPlacemark, countryCode: clPlacemark.isoCountryCode ?? "PH") == false {
            // We need a new clPlacemark based on subLocality
            let newAddress = buildAddress(for: clPlacemark, startPlacemarkLevel: .subLocality)
            do {
                let subLocalityPlacemark = try await geocoder.geocodeAddressString(newAddress)
                if let newPlacemark = subLocalityPlacemark.first {
                    printPlacemarkInfo(newPlacemark, address: newAddress)
                    print("Error with name. New Placemark: \(newPlacemark)")
                    return newPlacemark
                }
            } catch {
                print("Error with name. Have to get SubLocality new Address: \(newAddress)")
                throw LOKError(.failedToGetCLPlacemark)
            }
        }

        return clPlacemark
    }

    func buildAddress(for clPlacemark: CLPlacemark, startPlacemarkLevel: PlacemarkLevel, name: String? = nil) -> String {

        var address = ""
        let level = startPlacemarkLevel.rawValue
        if let levelIndex: Int = PlacemarkLevel(rawValue: level)?.order {
            for placemarkLevel in PlacemarkLevel.allCases {
                if placemarkLevel.order < startPlacemarkLevel.order {
                    // Do nothing
                } else {
                    // print("levelIndex = \(placemarkLevel.rawValue)")
                    if let value: String = clPlacemark.value(forKey: placemarkLevel.rawValue) as? String {
                        // print("value = \(value)")
                        if placemarkLevel.order >= levelIndex {
                            address += "\(value)"
                            if placemarkLevel.order != (PlacemarkLevel.allCases.count) {
                                address += ", "
                                // print("address \(placemarkLevel) = \(address)")
                            }
                        }
                    }
                }
            }
        }

        //: Add name if passed.
        if let name = name {
            address = name + ", " + address
        }

        print("final address: \(address)")
        return address
    }

    /// Verify the name of CLPlacemark.
    /// We need to check if the placemark name is a thoroughfare.
    /// - Parameters:
    ///   - clPlacemark: CLPlacemark
    ///   - countryCode: Country Code
    /// - Returns: TRUE if the CLPlacemark.name is good
    func verifyPlacemarkName(_ clPlacemark: CLPlacemark, countryCode: Country.RawValue = "PH") -> Bool {
        let clPlacemarkName         = clPlacemark.name
        let clPlacemarkThoroughfare = clPlacemark.thoroughfare

        // 1. Check that we have a name
        guard clPlacemark.name != nil else { return false }

        // 2. Check that NAME against THOROUGHFARE
        // A. is name == thoroughfare?
        if clPlacemarkName == clPlacemarkThoroughfare {
            // It's a street!
            return true
        }

        // B. Check if thoroughfare is in Name string
        if let clPlacemarkThoroughfare = clPlacemarkThoroughfare, let clPlacemarkName = clPlacemarkName {
            if clPlacemarkName.contains(clPlacemarkThoroughfare) {
                print("thoroughfare is in name = true")
                return false
            }
        }

        // C.
        var streetWords: [String] = []

        let country = Country.init(rawValue: countryCode)
        switch country {
        case .southKorea:
            streetWords = ["-gil", "-ro", "-daero"]
        default:
            streetWords = ["Street", "Avenue", "Highway", "Road"]
        }

        if let clPlacemarkName = clPlacemarkName {
            let check1 = streetWords.contains(where: clPlacemarkName.contains)
            let decimalCharacters = CharacterSet.decimalDigits
            let check2 = clPlacemarkName.rangeOfCharacter(from: decimalCharacters)
            if (check1 == true && check2 != nil) ||
                (clPlacemarkName.isNumeric) {
                // We have a street name. Let's NOT add this
                print("NOT ADDING: \(clPlacemarkName) at name level.")
                return false
            } else {
                return true
            }
        }
        return true
    }

    func printPlacemarkInfo(_ placemark: CLPlacemark, address: String? = "") {
        print("=========")
        print("For Address: \(String(describing: address))")
        print("Name: \(String(describing: placemark.name))")
        print("SubThoroughfare: \(String(describing: placemark.subThoroughfare))")
        print("Thoroughfare: \(String(describing: placemark.thoroughfare))")
        print("SubLocality: \(String(describing: placemark.subLocality))")
        print("Locality: \(String(describing: placemark.locality))")
        print("SubAdministrative Area: \(String(describing: placemark.subAdministrativeArea))")
        print("Administrative Area: \(String(describing: placemark.administrativeArea))")
        print("Country: \(String(describing: placemark.country))")
        print("Country Code: \(String(describing: placemark.isoCountryCode))")
        print("Thoroughfare: \(String(describing: placemark.thoroughfare))")
        print("SubThoroughfare: \(String(describing: placemark.subThoroughfare))")
        if let coordinate = placemark.location?.coordinate {
            print("Coordinate: \(String(describing: coordinate.latitude)) . \(String(describing: coordinate.longitude))")
        }
        print("Areas Of Interest: \(String(describing: placemark.areasOfInterest))")
        print("=========")

    }

    func resetSearch() {
        searchResults = []
        searchResultsNearYouClPlacemark = []
    }
}
