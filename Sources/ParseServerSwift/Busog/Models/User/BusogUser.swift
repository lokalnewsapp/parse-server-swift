//
//  BusogUser.swift
//
//
//  Created by Jayson Ng on 01/13/24.
//

import Foundation
import ParseSwift

//: Extend User object for custom project data
extension User {
    var busogUserFavorites: BusogUserFavorites? { userCustom?.busogFavorites }
}

//: User Custom is a required
struct UserCustom: ParseObject, UserElement, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Your custom keys.
    var user: Pointer<User>?
    var busogFavorites: BusogUserFavorites?

}

struct BusogUserFavorites: ParseObject, UserElement, Equatable {

    static func == (lhs: BusogUserFavorites, rhs: BusogUserFavorites) -> Bool {
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

    //: Your Custom Properties
    var user: Pointer<User>?
    var foods: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "foods", object: BusogFood.self)
    }

}


