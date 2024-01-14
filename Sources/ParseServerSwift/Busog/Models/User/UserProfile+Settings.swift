//
//  UserProfile.swift
//
//  Created by Jayson Ng on 4/4/21.
//
import Foundation
import ParseSwift

protocol UserElement { var user: Pointer<User>? { get } }

struct UserProfile: ParseObject, UserElement, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Your custom keys.
    var lastName: String?
    var firstName: String?

    var fullName: String? {
        String("\(firstName ?? "") \(lastName ?? "")")
            .trimmed()
    }

    var notes: String?
    var followedTags: [String]?

    var photo: LokalityImage?
    var user: Pointer<User>?
}

// UserSettings is where we place settings.
// that the user himself has control over.
struct UserSettings: ParseObject, UserElement, Identifiable {

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
    var isPrivateAccount: Bool?

    var blockedUsers: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "blockedUsers", object: User.self)
    }
    var followedTags: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "followedTags", object: Tag.self)
    }
    var defaultLokality: Pointer<Lokality>?
    var defaultLocation: Pointer<Location>?
}
