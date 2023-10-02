//
//  LocationCloudCode.swift
//  Lokality
//
//  Created by Jayson Ng on 6/26/22.
//

import ParseSwift
import CoreLocation

// MARK: - --------------  Location --------------
extension Location {

    struct Get: ParseCloudable {

        enum GetMethod: String {
            case id     = "getLocationById"
            case name   = "getLocationByName"
            case tag    = "getLocationByTag"
        }

        //: Return type of your Cloud Function
        typealias ReturnType = Location
        var functionJobName: String

        //: Parameters
        var name: String?
        var tag: String?
        var objectId: String?
        var center: ParseGeoPoint?

        init(with method: GetMethod, parameter: String, center: ParseGeoPoint? = nil) {
            self.functionJobName = method.rawValue

            self.name       = parameter
            self.tag        = parameter
            self.objectId   = parameter
            self.center     = center

        }
    }

    struct Create: ParseCloudable {

        //: Return type of your Cloud Function
        typealias ReturnType = Location
        var functionJobName: String = "createLocation"

        //: Parameters
        var locationDetails: LocationDetails
        var parentDetails: LocationDetails?
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

extension LocationPlacemark.Get {

    init(placemark: CLPlacemark, distance: Double = 1.5) throws {

        self.name           = ""
        self.center         = try ParseGeoPoint(latitude: 0, longitude: 0)
        self.distance       = distance

        if let latitude     = placemark.location?.coordinate.latitude,
           let longitude    = placemark.location?.coordinate.longitude {

            do {
                let geopoint  = try ParseGeoPoint(latitude: latitude, longitude: longitude)
                name        = placemark.name ?? ""
                center      = geopoint
            } catch let error {
                throw error
            }
        }
    }
}

extension LocationPlacemark.Create {

    init(placemark: CLPlacemark) throws {

        let address = LocationStore().buildAddress(for: placemark, startPlacemarkLevel: .name)
        guard address != "" else { throw LOKError(.noAddressEntered)}

        if let latitude = placemark.location?.coordinate.latitude,
           let longitude = placemark.location?.coordinate.longitude {
            do {
                let center = try ParseGeoPoint(latitude: latitude, longitude: longitude)
                var locationPlacemark = LocationPlacemark()
                locationPlacemark.address                   = address
                locationPlacemark.center                    = center
                locationPlacemark.radius                    = 1.0 // placemark.region
                locationPlacemark.name                      = placemark.name ?? ""
                locationPlacemark.thoroughfare              = placemark.thoroughfare
                locationPlacemark.subLocality               = placemark.subLocality
                locationPlacemark.locality                  = placemark.locality
                locationPlacemark.subAdministrativeArea     = placemark.subAdministrativeArea
                locationPlacemark.administrativeArea        = placemark.administrativeArea
                locationPlacemark.country                   = placemark.country
                locationPlacemark.isoCountryCode            = placemark.isoCountryCode
                locationPlacemark.areasOfInterest           = placemark.areasOfInterest

                self.placemark = locationPlacemark
            } catch let error {
                throw error
            }

        } else {
            self.placemark = nil
        }
    }
}

// MARK: - --------------  Location Details --------------
extension LocationDetails {

    struct GetById: ParseCloudable {

        //: Return type of your Cloud Function
        typealias ReturnType = LocationDetails
        var functionJobName: String = "getLocationDetailsById"

        //: Parameters
        var id: String
    }

    struct Create: ParseCloudable {

        //: Return type of your Cloud Function
        typealias ReturnType = LocationDetails
        var functionJobName: String = "createLocationDetails"

        //: Parameters
        var locationDetails: LocationDetails
    }

    struct Update: ParseCloudable {
        //: Return type of your Cloud Function
        typealias ReturnType = LocationDetails
        var functionJobName: String = "updateLocationDetails"

        //: Parameters
        var locationDetails: LocationDetails
        var objectId: String
    }
}

extension LocationDetails.Create {

    init(placemark: LocationPlacemark, level: PlacemarkLevel = .name, areaType: LocationAreaType? = nil) {

        var details              = LocationDetails()
        details.name             = placemark.name
        details.mainTag          = nil
        details.mainTagString    = placemark.name?.cleanTag()
        details.areaType         = LocationStore().findAreaType(for: areaType,
                                                               placemark: placemark,
                                                               placemarkLevel: level)
        details.placemark        = placemark
        details.center           = placemark.center
        details.namePrefix       = ""
        details.nameSuffix       = ""
        details.description      = ""
        details.descriptionMore  = ""
        details.altNames         = []
        // locationDetails.tags             = []
        // locationDetails.images           = nil

        self.locationDetails    = details

    }
}

// MARK: - -------------- LocationAreaTypeByCountry --------------
extension LocationAreaTypeByCountry {

    struct Get: ParseCloudable {

        //: Return type of your Cloud Function
        typealias ReturnType = LocationAreaTypeByCountry
        var functionJobName: String = "getLocationAreaTypeByCountry"

        //: Parameters
        var countryCode: String

    }
}

// MARK: - -------------- LocationAreaType --------------
extension LocationAreaType {

    struct Find: ParseCloudable {

        //: Return type of your Cloud Function
        typealias ReturnType = LocationAreaType
        var functionJobName: String = "findLocationAreaType"

        //: Parameters
        var placemark: LocationPlacemark
        var level: String

    }
}
