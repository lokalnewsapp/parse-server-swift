//
//  UserFavorites+Likes.swift
//  Lokality
//
//  Created by Jayson Ng on 11/30/23.
//

import Foundation
import ParseSwift
import os.log

struct UserFavorites: ParseObject, UserElement, Identifiable {

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
    var locations: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "locations", object: Location.self)
    }

    var lokalities: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "lokalities", object: Lokality.self)
    }

    var posts: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "posts", object: Post.self)
    }
}

struct UserLikes: ParseObject, UserElement, Identifiable {

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
    var posts: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "posts", object: Post.self)
    }

    var comments: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "posts", object: PostComment.self)
    }

}
