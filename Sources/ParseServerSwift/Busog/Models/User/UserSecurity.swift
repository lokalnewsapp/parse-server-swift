//
//  UserSecurity.swift
//  Lokality
//
//  Created by Jayson Ng on 12/4/23.
//

import Foundation
import ParseSwift
//import os.log

struct UserSecurity: ParseObject, UserElement, Identifiable {

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
    var loginHistory: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "loginHistory", object: UserLoginHistory.self)
    }
    var failedLoginAttemps: Int?
    var emailAddressHistory: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "emailAddressHistory", object: UserEmailAddressHistory.self)
    }
}

struct UserLoginHistory: ParseObject, Identifiable {

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
    var ipAddress: String?
    var device: String?

}

struct UserEmailAddressHistory: ParseObject, Identifiable {

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
    var email: String?

}
