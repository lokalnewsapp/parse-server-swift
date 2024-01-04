//
//  LocationStoreVapor.swift
//  
//
//  Created by Jayson Ng on 7/13/23.
//

import Foundation
import CoreLocation
import SwiftUI
import ParseSwift
import MapKit
import Countries
//import os.log
import Vapor

extension LocationStore {
    
    // MARK: - --------------  Vapor Main Location Methods ---------------
    func getLocation(options: API.Options,
                     byName name: String,
                     andCenter center: ParseGeoPoint) async throws -> Location {
        do {
            let nameQueries = createLocationNameConstraints(from: name)
            var constraints = [QueryConstraint]()
            constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: center, distance: 0.01))
            constraints.append(or(queries: nameQueries))
            let inQuery = Query<LocationDetails>(constraints)
            let query = Location.query("details" == inQuery).includeAll().where("active" == true)
            
            // Query using the User's credentials who called this function
            dump(options)
            return try await query.first(options: options)
            
            
        } catch let error as ParseError {
            throw LOKError(.parseError(error))
        }
    }
}

// MARK: - -------------- Get Location Helpers ---------------
extension LocationStore {
    private func getLocation(inQuery: Query<LocationDetails>) async throws -> Location {
        let query = Location.query("details" == inQuery).includeAll().where("active" == true)
        do {
            return try await query.first()
        } catch {
            throw LOKError(.failedToGetLocation)
        }
    }

    private func createLocationNameConstraints(from name: String) -> [Query<LocationDetails>] {
        let constraint1 = matchesRegex(key: "name", regex: name, modifiers: "i")
        let query1 = LocationDetails.query(constraint1)
        let constraint2 = matchesRegex(key: "altNames", regex: name, modifiers: "i")
        let query2 = LocationDetails.query(constraint2)
        let constraint3 = matchesRegex(key: "fullName", regex: name, modifiers: "i")
        let query3 = LocationDetails.query(constraint3)
        return [query1, query2, query3]
    }

    private func createLocationConstraints(
        placemark: LocationPlacemark,
        placemarkLevel: PlacemarkLevel = .name
    ) -> [QueryConstraint] {

        var constraints = [QueryConstraint]()

        if let center = placemark.center {
            switch placemarkLevel {
            case .name, .thoroughfare:
                let distance = 1.0
                constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: center, distance: distance))
            case .subLocality:
                let distance = 10.0
                constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: center, distance: distance))
            case .locality:
                let distance = 50.0
                constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: center, distance: distance))
            case .subAdministrativeArea:
                let distance = 150
                constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: center, distance: Double(distance)))
            case .administrativeArea, .country:
                // Constraint should be parented to country.
                let queryCountry = LocationDetails.query("countryCode" == placemark.isoCountryCode )
                constraints.append(and(queries: [queryCountry]))
            }
        }
        let queries = createLocationNameConstraints(from: placemark.name ?? "")
        constraints.append(or(queries: queries))
        return constraints
    }

}
