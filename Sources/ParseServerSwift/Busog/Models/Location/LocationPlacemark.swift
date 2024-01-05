//
//  LocationPlacemark.swift
//  Lokality
//
//  Created by Jayson Ng on 11/9/21.
//

import Foundation
import ParseSwift
// import CoreLocation
// import os.log

struct LocationPlacemark: ParseObject, Identifiable, Codable {

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Object's own properties.
    var address: String?

    // From CLPlacemark
    var name: String?
    var thoroughfare: String?
    var subLocality: String?
    var locality: String?
    var subAdministrativeArea: String?
    var administrativeArea: String?
    var country: String?
    var isoCountryCode: String?
    var center: ParseGeoPoint?
    var radius: Double?
    var areasOfInterest: [String?]?

    // MARK: - --------------  Inits  ---------------
    init() {
        var acl                 = ParseACL()
        acl.publicRead          = true
        acl.publicWrite         = false
        ACL                     = acl
    }

    init(objectId: String?) {
        self.init()
        self.objectId = objectId
    }

//    init(sample: LocationSample) {
//        self.init()
//        self.objectId   = sample.details.placemark?.objectId
//        name            = sample.details.placemark?.name
//        address         = sample.details.placemark?.address
//        subLocality     = sample.details.placemark?.subLocality
//        center          = sample.details.placemark?.center
//        isoCountryCode  = sample.details.placemark?.isoCountryCode ?? sample.details.countryCode
//    }
}

extension LocationPlacemark {

    // MARK: - --------------  Helpers  ---------------
    func getAttribute(for attribute: Placemark) -> String? {
        switch attribute {
        case .name: return self.name ?? nil
        case .thoroughfare: return self.thoroughfare ?? nil
        case .subLocality: return self.subLocality ?? nil
        case .locality: return self.locality ?? nil
        case .administrativeArea: return self.administrativeArea ?? nil
        case .subAdministrativeArea: return self.subAdministrativeArea ?? nil
        case .country: return self.country ?? nil

        // TODO: This shouldn't be here. Do we change the case to "default"? and return nil instead?
        case .areasOfInterest:
            print("Returning only the 1st result of an array. There may be more items behind.")
            return self.areasOfInterest?.first ?? nil
        //    case .timeZone                      :       return self.timeZone?.description ?? nil
        }
    }

    func getAreasOfInterest() -> [String?]? { self.areasOfInterest }

}

// MARK: - --------------  Placemark Enums  ---------------
enum Placemark: String, CaseIterable, CustomStringConvertible {

    var description: String {
        switch self {
        case .name: return "name"
        case .thoroughfare: return "thoroughfare"
        case .subLocality: return "subLocality"
        case .locality: return "locality"
        case .subAdministrativeArea: return "subAdministrativeArea"
        case .administrativeArea: return "administrativeArea"
        //    case .region                    :       return "region"
        case .country: return "country"
        case .areasOfInterest: return "areasOfInterest"
        //    case .timeZone                  :       return "timeZone"
        }
    }

    case name
    case thoroughfare
    case subLocality
    case locality
    case subAdministrativeArea
    case administrativeArea
    case country
    case areasOfInterest
    //  case region
    //  case timeZone

}

enum PlacemarkLevel: String, CaseIterable, CustomStringConvertible {
    var description: String {
        switch self {
        case .name: return "name"
        case .thoroughfare: return "thoroughfare"
        case .subLocality: return "subLocality"
        case .locality: return "locality"
        case .subAdministrativeArea: return "subAdministrativeArea"
        case .administrativeArea: return "administrativeArea"
        case .country: return "country"
        }
    }

    case name
    case thoroughfare
    case subLocality
    case locality
    case subAdministrativeArea
    case administrativeArea
    case country

    var order: Int {
        switch self {
        case .name: return 1
        case .thoroughfare: return 2
        case .subLocality: return 3
        case .locality: return 4
        case .subAdministrativeArea: return 5
        case .administrativeArea: return 6
        case .country: return 7
        }
    }
}

// MARK: - --------------  Location Placemark --------------
extension LocationPlacemark {

    struct Get: ParseCloudable {

        //: Return type of your Cloud Function
        typealias ReturnType = LocationPlacemark
        var functionJobName: String = "getLocationPlacemark"

        //: Parameters
        var name: String
        var center: ParseGeoPoint
        var distance: Double

    }

    struct Create: ParseCloudable {

        //: Return type of your Cloud Function
        typealias ReturnType = LocationPlacemark
        var functionJobName: String = "createLocationPlacemark"

        //: Parameters
        var placemark: LocationPlacemark?

    }

}
//
//extension LocationPlacemark.Get {
//
//    init(placemark: CLPlacemark, distance: Double = 1.5) throws {
//
//        self.name           = ""
//        self.center         = try ParseGeoPoint(latitude: 0, longitude: 0)
//        self.distance       = distance
//
//        if let latitude     = placemark.location?.coordinate.latitude,
//           let longitude    = placemark.location?.coordinate.longitude {
//
//            do {
//                let geopoint  = try ParseGeoPoint(latitude: latitude, longitude: longitude)
//                name        = placemark.name ?? ""
//                center      = geopoint
//            } catch let error {
//                throw error
//            }
//        }
//    }
//}

//extension LocationPlacemark.Create {
//
//    init(placemark: CLPlacemark) throws {
//
//        let address = LocationStore().buildAddress(for: placemark, startPlacemarkLevel: .name)
//        guard address != "" else { throw LOKError(.noAddressEntered)}
//
//        if let latitude = placemark.location?.coordinate.latitude,
//           let longitude = placemark.location?.coordinate.longitude {
//            do {
//                let center = try ParseGeoPoint(latitude: latitude, longitude: longitude)
//                var locationPlacemark = LocationPlacemark()
//                locationPlacemark.address                   = address
//                locationPlacemark.center                    = center
//                locationPlacemark.radius                    = 1.0 // placemark.region
//                locationPlacemark.name                      = placemark.name ?? ""
//                locationPlacemark.thoroughfare              = placemark.thoroughfare
//                locationPlacemark.subLocality               = placemark.subLocality
//                locationPlacemark.locality                  = placemark.locality
//                locationPlacemark.subAdministrativeArea     = placemark.subAdministrativeArea
//                locationPlacemark.administrativeArea        = placemark.administrativeArea
//                locationPlacemark.country                   = placemark.country
//                locationPlacemark.isoCountryCode            = placemark.isoCountryCode
//                locationPlacemark.areasOfInterest           = placemark.areasOfInterest
//
//                self.placemark = locationPlacemark
//            } catch let error {
//                throw error
//            }
//
//        } else {
//            self.placemark = nil
//        }
//    }
//}
