//
//  GameScore.swift
//  
//
//  Created by Corey E. Baker on 6/21/22.
//

import Foundation
import ParseSwift

/**
 An example `ParseObject`. This is for testing. You can
 remove when creating your application.
 */
struct Lokality: ParseObject, Identifiable {
        
    //: For Identifiable
    var id: String? { objectId }
    
    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var altNames: [String]?
    var tag: String?
    var altTags: [String]?
    var slogan: String?
    var description: String?
    var socials: LokalitySocials?

    var lokalityType: LokalityType?
    var lokalityTypeDetails: LokalityTypeDetails?
    
    var isActive: Bool?
    var isFeatured: Bool?
    var center: ParseGeoPoint?
    var radius: Double?
    var boundary: [ParseGeoPoint]?
    var featuredImage: LokalityImage?
    var images: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "images", object: LokalityImage.self)
    }
    
    var addedBy: Pointer<User>?
    var status: Status?
    
    var lokalityCustom: LokalityCustom?

    var locations: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "locations", object: Location.self)
    }
    
    var landmarks: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "landmarks", object: Location.self)
    }

    var moderators: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "moderators", object: User.self)
    }

    var admins: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "landmarks", object: User.self)
    }

}

extension Lokality {
    init(objectId: String) {
        self.objectId = objectId
    }
}

extension Lokality {
    
    // Implement your own version of merge.
    func merge(with object: Self) throws -> Self {
        var updated = try mergeParse(with: object)
        if updated.shouldRestoreKey(\.name,
                                     original: object) {
            updated.name = object.name
        }
        return updated
    }
}

//: Lokality Static Helpers
extension Lokality {
    // MARK: - --------------  Static Methods  --------------

}

extension Lokality {

    
    /// Create Tag Queries Helper
    // MARK: - --------------  Helper Methods  --------------
    static func createLokalityTagQueries(from name: String) -> [Query<Lokality>] {
        let trimmed = name.trimmed()
        let constraint1 = matchesRegex(key: "tag", regex: trimmed, modifiers: "i")
        let query1 = Lokality.query(constraint1)
        let constraint2 = matchesRegex(key: "altTags", regex: trimmed, modifiers: "i")
        let query2 = Lokality.query(constraint2)
        return [query1, query2]
    }

    static func createLokalityNameQueries(from name: String) -> [Query<Lokality>] {
        let trimmed = name.trimmed()

        let constraint1 = matchesRegex(key: "name", regex: trimmed, modifiers: "i")
        let query1 = Lokality.query(constraint1)
        let constraint2 = matchesRegex(key: "altNames", regex: trimmed, modifiers: "i")
        let query2 = Lokality.query(constraint2)
        return [query1, query2]
    }
    
    static func createLokalityNameTagQueries(from name: String) -> [Query<Lokality>] {
        let trimmed = name.trimmed()
        let constraints = matchesRegex(key: "name", regex: trimmed)
        let query1 = Lokality.query(constraints)
        let constraints2 = matchesRegex(key: "altNames", regex: trimmed, modifiers: "i")
        let query2 = Lokality.query(constraints2)
        let constraints3 = matchesRegex(key: "tag", regex: trimmed.replacingOccurrences(of: " ", with: ""), modifiers: "i")
        let query3 = Lokality.query(constraints3)
        let constraints4 = matchesRegex(key: "altTags", regex: trimmed.replacingOccurrences(of: " ", with: ""), modifiers: "i")
        let query4 = Lokality.query(constraints4)
        return [query1, query2, query3, query4]
    }
}

extension Lokality {

    // MARK: - --------------  Static Methods  --------------

    /// Get All Lokalities using CloudCode Vapor
    /// - Parameter tag: The tag to search for.
    func getByTag(_ tag: String) async throws -> Lokality {

        let getLokality = GetLokalityByTag(tag: tag)

        do {
            return try await getLokality.runFunction()
        } catch {
            throw error
        }

    }

    /// Get All Lokalities using CloudCode Vapor
    /// - Parameter tag: The tag to search for.
    func getById(_ id: String) async throws -> Lokality {

        let getLokality = GetLokalityByObjectId(objectId: id)

        do {
            return try await getLokality.runFunction()
        } catch {
            throw error
        }

    }
    
    /// Get All Lokalities using CloudCode Vapor
    /// - Parameter limit: limit the number of returned items.
    static func getAll(limit: Int = 20) async throws -> [Lokality] {
        let getAllLokalities = GetAllLokalities(limit: limit)

        do {
            let lokalities = try await getAllLokalities.runFunction()
            print("All Lokalities: \(lokalities.count)")
            return lokalities
        } catch {
            print("error: \(error.localizedDescription)")
            throw error
        }
    }

    /// Search Lokalities using CloudCode Vapor
    /// - Parameter name: The name of the Lokality to search for
    static func search(name: String) async throws -> [Lokality?] {
        let searchLokalities = SearchLokalities(name: name)

        do {
            let results = try await searchLokalities.runFunction()
            print("Search Lokalities: \(results.count)")
            return results
        } catch {
            print("error: \(error.localizedDescription)")
            throw error
        }
    }

    /// Get Lokalities Near THIS Lokality
    func getNearYou() async throws -> [Lokality?] {
        guard let center = self.center else {
            return []
        }
        let centerCoordinate = Coordinate(latitude: center.latitude, longitude: center.longitude)

        let nearYouLokalities = GetLokalitiesNearYou(center: centerCoordinate)

        do {
            let results = try await nearYouLokalities.runFunction()
            print("Near You Lokalities: \(results.count)")
            return results
        } catch {
            print("error: \(error.localizedDescription)")
            throw error
        }
    }

}


//
//class BusogLokality: Equatable, Codable {
//    
//    static func == (lhs: BusogLokality, rhs: BusogLokality) -> Bool {
//        lhs.objectId == rhs.objectId
//    }
//    
//    //: Busog Location Details
//    var busogLokalityDetails: BusogLokalityDetails?
//    
//    //: Stored Properties
//    var lokality: Lokality?
//    
//    //: Computed Properties
//    var objectId: String? { lokality?.objectId }
//    var status: Status? { lokality?.status }
//    
//    //: Init
//    init(lokality: Lokality) {
//        self.lokality = lokality
//    }
//    
//}
