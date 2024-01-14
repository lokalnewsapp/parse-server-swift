//
//  PostComment.swift
//  Lokality
//
//  Created by Jayson Ng on 12/4/23.
//

import Foundation
import ParseSwift
//import os.log

struct PostComment: ParseObject {

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var user: Pointer<User>?
    var comment: String?
    var replies: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "posts", object: PostComment.self)
    }
}
