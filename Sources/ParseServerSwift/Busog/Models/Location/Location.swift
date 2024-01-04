//
//  Location.swift
//  Lokality
//
//  Created by Jayson Ng on 5/19/21.

import Foundation
import ParseSwift
// import MapKit
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
    var isActive: Bool?
    var weight: Int?
    var details: LocationDetails?
    var parentDetails: ParentDetails?
    var parentLokality: Lokality?
    var status: Status?
    var relatedTags: [String]?

    var lokalities: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "lokalities", object: Lokality.self)
    }

    var addedBy: Pointer<User>?
    var test: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "locations")
    }

    //: For Lokality Ver. 2
    // var forumPosts: ParseRelation<Self>? {
    //    try? ParseRelation(parent: self, key: "forumPosts")
    // }

    //: For Reference only and should not be used for Queries.
    var fullName: String? {
        String("\(details?.namePrefix ?? "") \(details?.name ?? "") \(details?.nameSuffix ?? "")").trimmed()
    }
    var tag: String? { details?.tag }
//

    //: Non-Parse Properties
    // var region: MKCoordinateRegion
    // var locationAreaTypeByCountry: LocationAreaTypeByCountry?

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

    var featuredImage: LokalityImage? { self.details?.featuredImage }

    // MARK: - -------------- Sample Data ---------------
    #if DEBUG

    // let sample =  Bundle.main.decode([Location].self, from: "locationSample.json")
    // let samples =  Bundle.main.decode([Location].self, from: "locationSamples.json")
    // static var sample: Location = Location(sample: LocationSample(.stoDomingo))

    #endif

    // MARK: - --------------  Inits ---------------
    init() {

        // Setup ACL
        var acl                 = ParseACL()
        acl.publicRead          = true
        acl.publicWrite         = false
        ACL                     = acl

    }

    init(details: LocationDetails) {
        self.init()
        self.details = details
    }

//    init(sample: LocationSample) {
//        self.init()
//        self.objectId                      = sample.objectId
//        self.parentDetails                 = sample.parentDetails
//        self.details                       = sample.details

//        self.region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: (details?.center?.latitude ?? 0.0), longitude: (details?.center?.longitude ?? 0.0)),
//            latitudinalMeters: details?.radius ?? 1000,
//            longitudinalMeters: details?.radius ?? 1000)
//    }

}


// extension Location: Codable {
//
//    enum CodingKeys: String, CodingKey {
//        case objectId
//        case active
//        case details
//        case parentDetails
//        case fullName
//        case mainTagString
//        case longitude, latitude
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(objectId, forKey: .objectId)
//        try container.encode(active, forKey: .active)
//        try container.encode(details, forKey: .details)
//        try container.encode(parentDetails, forKey: .parentDetails)
//        try container.encode(fullName, forKey: .fullName)
//        try container.encode(mainTagString, forKey: .mainTagString)
//
//        // try container.encode(region.center.longitude, forKey: .longitude)
//        // try container.encode(region.center.latitude, forKey: .latitude)
//
//    }
//
//    public init(from decoder: Decoder) throws {
//        // self.init()
//
//        let values          = try decoder.container(keyedBy: CodingKeys.self)
//        let objectId        = try values.decode(String.self, forKey: .objectId)
//        let active          = try values.decode(Bool.self, forKey: .active)
//        let details         = try values.decode(LocationDetails.self, forKey: .details)
//        let parentDetails   = try values.decode(LocationDetails.self, forKey: .parentDetails)
//
//        let locationDetails = try values.nestedContainer(keyedBy: LocationDetailInfoKeys.self, forKey: .details)
//        let latitude        = try locationDetails.decode(Double.self, forKey: .latitude)
//        let longitude       = try locationDetails.decode(Double.self, forKey: .longitude)
//
//        self.objectId       = objectId
//        self.active         = active
//        self.details        = details
//        self.parentDetails  = parentDetails
//
//        //: Map Region
//        var latitude        = 0.0
//        var longitude       = 0.0
//
//        if let center = details.center {
//            latitude        = center.latitude
//            longitude       = center.longitude
//        }
//
//        self.region         = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
//            latitudinalMeters: details.radius ?? 1000,
//            longitudinalMeters: parentDetails.radius ?? 1000)
//    }
//
// }
