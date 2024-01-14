//
//  UserElements.swift
//
//
//  Created by Jayson Ng on 1/14/24.
//

import Foundation
import ParseSwift

extension User {
    
    enum UserElements: String, CaseIterable {
        
        case profile    = "UserProfile"
        case settings   = "UserSettings"
        case favorites  = "UserFavorites"
        case likes      = "UserLikes"
        case security   = "UserSecurity"
    
    }
    
}

extension User.UserElements {
    
    /// Return the UserElement from the given object
    /// - Parameter element: Object conforming to the UserElement Protocol
    /// - Returns: case of UserElements or nil if no match is found.
    static func getElement(from element: UserElement) -> User.UserElements? {
        let type = String(describing: type(of: element))

        if type == User.UserElements.profile.rawValue {
            return .profile
        } else if type == User.UserElements.settings.rawValue {
            return .settings
        } else if type == User.UserElements.favorites.rawValue {
            return .favorites
        } else if type == User.UserElements.likes.rawValue {
            return .likes
        } else if type == User.UserElements.security.rawValue {
            return .security
        } else {
            return nil
        }
    }
        
}



