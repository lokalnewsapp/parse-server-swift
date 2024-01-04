//
//  Location.swift
//  Location
//
//  Created by Jayson Ng on 07/03/23.

import Foundation
import CoreLocation
import ParseSwift
import MapKit
import Countries

// MARK: - --------------  TypeAliases  ---------------
typealias Locations = [Location]

struct Location: ParseObject, Equatable {

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.objectId == rhs.objectId
    }

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Object's own properties.
    var active: Bool?
    var details: LocationDetails?
    var parentDetails: ParentDetails?
    // var countryCode: String?

    //: For Reference only and should not be used for Queries.
    var fullName: String? {
        String("\(details?.namePrefix ?? "") \(details?.name ?? "") \(details?.nameSuffix ?? "")").trimmed()
    }
    var tag: String? { details?.mainTag?.name }

    var test: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "test")
    }

    //: Non-Parse Properties
    // var region: MKCoordinateRegion
    var locationAreaTypeByCountry: LocationAreaTypeByCountry?

    //: Computed Properties
    var name: String? {
        if details?.name == nil || details?.name == "" {
            return nil
        } else {
            return String("\(details?.namePrefix ?? "") \(details?.name ?? "") \(details?.nameSuffix ?? "")").trimmed()
        }
    }

    var parentName: String? {
        String("\(parentDetails?.namePrefix ?? "") \(parentDetails?.name ?? "") \(parentDetails?.nameSuffix ?? "")").trimmed()
    }

    var coordinate: CLLocationCoordinate2D {
        if let center = details?.center {
            return center.toCLLocationCoordinate2D
        } else {
            //Logger.location.error("Location has no GeoPoint")
            let coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            return coordinate
        }
    }

    //var featuredImage: LokalityImage? { self.details?.featuredImage }


    // MARK: - --------------  Inits ---------------
    init() {
        var acl                 = ParseACL()
        acl.publicRead          = true
        acl.publicWrite         = false
        ACL                     = acl
    }

    init(details: LocationDetails) {
        self.init()
        self.details = details
        // self.details?..name = NSLocalizedString("Empty Location", comment: "Empty Location")
    }

}
