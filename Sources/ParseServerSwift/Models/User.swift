//
//  User.swift
//
//
//  Created by Corey E. Baker on 6/20/22.
//

import Foundation
import ParseSwift

/**
 An example `ParseUser`. You will want to add custom
 properties to reflect the `ParseUser` on your Parse Server.
 */
struct User: ParseCloudUser {

    //: Parse User Parameters
    var authData: [String: [String: String]?]?
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    var sessionToken: String?
    var _failed_login_count: Int?
    var _account_lockout_expires_at: Date?
    
    
    //: Your custom keys.
    var privacy: Agreement?
    var tos: Agreement?
    var status: Status?

    var isBanned: Bool?
    var isFlagged: Bool?
    var flaggedBy: Pointer<User>?
    var isVerifiedUser: Bool?
    var userVerifiedDetails: Pointer<UserVerifiedDetails>?
    var isPremiumUser: Bool?
    var userPremiumDetails: Pointer<UserPremiumDetails>?

    var userCustom: UserCustom?
    var userProfile: UserProfile?
    var userSettings: UserSettings?
    var userSecurity: UserSecurity?
    var userFavorites: UserFavorites?
    var userLikes: UserLikes?

    var userAddress: UserAddress?

    //: Properties for Swift
    var currentVerifiedEmailContainer: String?

}

struct UserVerifiedDetails: ParseObject {

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var user: Pointer<User>?
    var notes: String?
    var verifiedOn: Date?
    var verifiedBy: Pointer<User>?
}

struct UserPremiumDetails: ParseObject {

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var user: Pointer<User>?
    var notes: String?
    var paidOn: Date?
    var details: String?

}

struct UserAddress: ParseObject {

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var user: Pointer<User>?
    var barangay: String?
    var city: Date?
    var province: String?
    var isoCountryCode: String?

}
