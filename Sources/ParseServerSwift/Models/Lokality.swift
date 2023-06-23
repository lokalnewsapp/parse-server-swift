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
struct Lokality: ParseObject {
    // These are required by ParseObject.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own properties.
    var name: String?
    var tag: String?
    var altTags: [String]?
    var description: String?

    
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
