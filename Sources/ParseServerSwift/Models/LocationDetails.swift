//
//  LocationDetails.swift
//  Lokality
//
//  Created by Jayson Ng on 11/20/21.
//

import Foundation
import ParseSwift
import Countries
import CoreLocation

typealias ParentDetails = LocationDetails

struct LocationDetails: ParseObject, Identifiable, Equatable {

    //: For Identifiable
    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    // Name
    var namePrefix: String?
    var name: String?
    var nameSuffix: String?
    var altNames: [String]?
    var countryCode: String?
    var placemark: LocationPlacemark?

    var areaType: LocationAreaType?
    var center: ParseGeoPoint?
    var radius: Double?
    var boundary: [ParseGeoPoint]?

    var mainTag: Tag?
    var mainTagString: String?
    var featuredImage: LokalityImage?

    // Description
    var description: String?
    var descriptionMore: String?
    var descriptionBy: Pointer<User>?

    //: ParseRelations
    var tags: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "tags")
    }

    var images: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "images")
    }

    var nearBy: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "nearBy")
    }

    // MARK: - --------------  Inits  ---------------
    init() {
        self.name = NSLocalizedString("Empty Location", comment: "Empty Location")

        // MARK: - --------------  ACL  ---------------
        var acl                 = ParseACL()
        acl.publicRead          = true
        acl.publicWrite         = false
        acl.setWriteAccess(roleName: "admin", value: true)
        ACL                     = acl
    }

    // Init for Creating a New Location
    init(newLocation: Bool = true, locationPlacemark: LocationPlacemark, radius: Double? = 1.0) {
        self.init()
        self.name               = locationPlacemark.name
        self.altNames           = []
        namePrefix              = ""
        nameSuffix              = ""
        description             = ""
        descriptionMore         = ""

        // MARK: - --------------  Center + Placemark Data  ---------------
        self.radius             = radius
        placemark               = locationPlacemark
        center                  = locationPlacemark.center
        countryCode             = locationPlacemark.isoCountryCode

        // MARK: - --------------  Boundary  ---------------
        //  boundary = [
        //          try ParseGeoPoint(latitude: 14.630033, longitude: 121.003032),
        //          try ParseGeoPoint(latitude: 14.627604, longitude: 121.004212),
        //          try ParseGeoPoint(latitude: 14.628663, longitude: 121.006529),
        //          try ParseGeoPoint(latitude: 14.631227, longitude: 121.005285)
        //        ]

    }

    // Init with Name
    init(name: String? = "", prefix: String? = "", suffix: String = "") {
        self.init()
        self.name               = name
        namePrefix              = prefix
        nameSuffix              = suffix
    }

    // Init with World
    init(world: Bool = true) {
        self.init()
        self.objectId = "N7XXoT8kuI"
    }

    // Init with ObjectId
    init(objectId: String) {
        self.init()
        self.objectId = objectId
    }

    // Init with Country
    init(country: Country) {
        self.init()
        self.objectId = country.objectId
    }

}

// MARK: - --------------  Country Extension   ---------------
extension Country {
    var objectId: String? {
        switch self {

        case .canada: return "UqRlvvpwWq"
        case .hongKong: return "lqpa4Nap0v"
        case .japan: return "ZlBzLXspBI"
        case .philippines: return "hniVsRWAnN"
        case .southKorea: return "VEXP3BEz0i"
        case .unitedStates: return "9h5vpvh7Ul"

        default:
            return nil
        }
    }
}
