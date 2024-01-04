//
//  LocationAreaType.swift
//  Lokality
//
//  Created by Jayson Ng on 6/14/21.
//

import Foundation
import ParseSwift
import Swift

struct LocationAreaType: ParseObject, Codable {
    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Object's own properties.
    var id: String? { objectId }
    var prefix: String?
    var name: String?
    var label: String?
    var weight: Int?
    var altNames: [String]?

    // MARK: - --------------  Static Properties and Methods  --------------
    static let types = Bundle.main.decode([LocationAreaType].self, from: "locationAreaTypes.json")

    // static let allTypes: [LocationAreaType] = LocationAreaType.getAllTypes()
}

extension LocationAreaType {

    init(objectId: String) {
        self.objectId = objectId
    }

    init(type: Types) {
        self.objectId = type.rawValue
    }

    enum Types: String {
        case country          = "ivAEdzDYAF"
        case barangay         = "kdW2TaUDpp"
        case street           = "4q6IkccBKs"
        case city             = "VQw1ATZ9cK"
    }

    static func getAllTypes() async throws -> [LocationAreaType] {
        let query = LocationAreaType.query().order([.ascending("name")])
        do {
            return try await query.find()
        } catch {
            throw error
        }

    }
}

struct LocationAreaTypeByCountry: ParseObject, Codable {

    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Object's own properties.    
    var thoroughfare: LocationAreaType?
    var subLocality: LocationAreaType?
    var locality: LocationAreaType?
    var administrativeArea: LocationAreaType?
    var subAdministrativeArea: LocationAreaType?
    var country: LocationAreaType?
    var isoCountry: String?

    // MARK: - --------------  Static Properties and Methods  --------------
    static let typesByCountry = Bundle.main.decode([LocationAreaTypeByCountry].self, from: "locationAreaTypesByCountry.json")

    static func forCountry(_ countryCode: String) -> LocationAreaTypeByCountry? {
        if let locationAreaTypeCountry = LocationAreaTypeByCountry.typesByCountry.first(where: { $0.isoCountry == countryCode }) {
            return locationAreaTypeCountry
        } else {
            return nil
        }
    }

    func getProperty(for property: PlacemarkLevel) -> LocationAreaType? {
        switch property {
        case .name: return nil
        case .thoroughfare: return self.thoroughfare
        case .subLocality: return self.subLocality ?? nil
        case .locality: return self.locality ?? nil
        case .administrativeArea: return self.administrativeArea ?? nil
        case .subAdministrativeArea: return self.subAdministrativeArea ?? nil
        case .country: return self.country ?? nil
        }
    }
}
