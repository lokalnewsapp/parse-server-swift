//
//  LokalityError.swift
//  Lokality
//
//  Created by Jayson Ng on 7/22/21.
//
//  Based on ParseError object
//

import Foundation
import ParseSwift
import os.log

typealias LOKError = LokalityError

//: TODO: fix this
extension LokalityError: LocalizedError { }

/**
 An object with a Lokality code and message.
 */
public struct LokalityError: Decodable, Swift.Error, Equatable {

    /// The value representing the error from the Parse Server.
    public let code: Code
    /// The text representing the error from the Parse Server.
    public let message: String

    /// A textual representation of this error.
    public var localizedDescription: String {
        return "LokalityError code=\(code) error=\(message)"
    }

    enum CodingKeys: String, CodingKey {
        case code
        case message = "error"
    }

    /**
     `LokalityError.Code` enum contains all custom error codes that are used
     as `code` for `Error` for callbacks on all classes.
     We will start with 1000's to not conflict with ParseError Codes
     */
    public enum Code: Swift.Error, Codable, CustomStringConvertible, Equatable {
        //: Parse
        case parseError(ParseError)

        //: General Lokality Codes 1000
        case nilValue
        case noInternetConnection
        case failedToGetSettings

        //: Saving 1100
        case failedToSave
        case failedToSaveUser
        case failedToSaveUserProfile
        case failedToSaveUserProfilePhoto

        //: Object 1500
        case failedToCreateObject
        case failedToCreatePointerObject

        //: User 2000
        case noUser
        case noUsername
        case userIsNotLoggedIn
        case loginFailed
        case logoutFailed
        case invalidCredentials
        case incorrectPassword

        //: User Profile / Settings Changes 2100
        case noProfilePhoto
        case noUserProfile
        case noUserSettings
        case emailIsNotVerified
        case emailsDoNotMatch
        case passwordsDoNotMatch
        case changePasswordFail
        case changeEmailFail
        case failedToGetUserElement
        case newPasswordSameAsCurrent

        //: User SignUp 2200
        case signUpFailed
        case invalidUsername
        case invalidPassword
        case passwordNeedsUppercase
        case passwordNeedsLowercase
        case passwordNeedsSpecialCharacter
        case passwordTooShort
        case passwordTooLong
        case passwordContainsSpaces

        //: Location Codes 3000
        case noPlacemark
        case noNameData
        case noPlacemarkName
        case noPlacemarkLevel
        case noCoordinate
        case noDeviceCoordinate
        case noAddressEntered
        case failedToBuildLocationTree
        case failedBuildAddressForPlacemark
        case failedToCreateLocation
        case failedToCreateLocationPlacemark
        case failedToGetLocation
        case failedToGetLocationPlacemark
        case failedToGetCLPlacemark
        case searchLocationFailed
        
        //: Lokality Codes 3500
        case failedToGetLokality
        case searchLokalityFailed

        //: Post Codes 4000
        case notAValidUrl
        case noPostPreview
        case cannotGetPreview
        case notInWhiteList
        case failedToGetURL
        case failedToGetURLInformation
        case failedToFormatDate
        case failedToSavePost
        case failedToGetPost

        //: Tag Codes 5000
        case noTag
        
        //: File 6000
        case noFileAttached
        case fileNotFound

        //: Log 7000
        case failedToSaveLog

        //: Type Aliases from ParseError.Code that we use in Lokality
        static var connectionFailed: LokalityError.Code {
            parseError(ParseError(code: .connectionFailed, message: "Connection to server failed."))
        }

        static var objectNotFound: LokalityError.Code {
            parseError(ParseError(code: .objectNotFound, message: "Object not found."))
        }

        static var invalidEmailAddress: LokalityError.Code {
            parseError(ParseError(code: .invalidEmailAddress, message: "Invalid email address."))
        }

        static var userEmailMissing: LokalityError.Code {
            parseError(ParseError(code: .userEmailMissing, message: "User Email is Missing"))
        }

        static var other: LokalityError.Code {
            parseError(ParseError(code: .other, message: "Unknown Error from server."))
        }

        // MARK: - -------------- LokalityError Codes ---------------
        public var description: String {
            switch self {

            //: Error
            case .parseError(let error): return "\(error.description)"

            case .nilValue: return "Nil Value."
            case .noInternetConnection: return "Please check your Internet connection"
            case .failedToGetSettings: return "Failed to get App Settings."

            case .failedToSave: return "Error Saving Item."
            case .failedToSaveUser: return "Error saving User Object."
            case .failedToSaveUserProfile: return "Error saving User Profile."
            case .failedToSaveUserProfilePhoto: return "Error saving Profile Photo."

            case .failedToCreateObject: return "Failed to create Object."
            case .failedToCreatePointerObject: return "Failed to create Pointer Object."

            //: User
            case .noUser: return "No User Object found."
            case .noUsername: return "There is no username."
            case .userIsNotLoggedIn: return "User is not logged in."
            case .loginFailed: return "Failed to login."
            case .logoutFailed: return "Logout failed."
            case .invalidCredentials: return "Please check your username or password."
            case .incorrectPassword: return "Incorrect Password."

            //: User Profile / Settings
            case .noProfilePhoto: return "No ProfilePhoto found."
            case .noUserProfile: return "No UserProfile found."
            case .noUserSettings: return "No UserSettings found."
            case .emailIsNotVerified: return "Your email has not been verified."
            case .emailsDoNotMatch: return "The email addresses do not match."
            case .passwordsDoNotMatch: return "The passwords do not match."
            case .changePasswordFail: return "There was a problem changing your password."
            case .changeEmailFail: return "There was a problem changing your email."
            case .failedToGetUserElement: return "Error getting UserProfile or UserSettings."

            //: User Sign Up
            case .signUpFailed: return "Failed to sign up new user."
            case .invalidUsername: return "The username should have at least 6 characters and not contain any special characters. "
            case .invalidPassword: return "Invalid password."
            case .passwordNeedsUppercase: return "The password needs at least 1 Uppercase character."
            case .passwordNeedsLowercase: return "The password needs at least 1 lowercase character."
            case .passwordNeedsSpecialCharacter: return "The password needs at least 1 special character."
            case .passwordTooShort: return "The password needs to be at least 8 characters."
            case .passwordTooLong: return "The password is too long!"
            case .passwordContainsSpaces: return "The password cannot contain spaces."
            case .newPasswordSameAsCurrent: return "The new password is the same as your current password."
            //: Location Related
            case .noNameData: return "No Name Assigned."
            case .noPlacemarkName: return "No Placemark Name."
            case .noPlacemark: return "No Placemark."
            case .noPlacemarkLevel: return "No Placemark Level."
            case .noCoordinate: return "No Coordinate Data."
            case .noDeviceCoordinate: return "No Device Coordinate"
            case .noAddressEntered: return "No Address Data."
            case .noTag: return "No Tag Found."
            case .searchLocationFailed: return "Search Location Failed."

            case .failedToBuildLocationTree: return "Failed to build Location Tree."
            case .failedBuildAddressForPlacemark: return "Failed to build Address for Placemark."
            case .failedToCreateLocation: return "Failed to create Location."
            case .failedToCreateLocationPlacemark: return "Failed to create LocationPlacemark."
            case .failedToGetLocation: return "Failed to get Location."
            case .failedToGetLocationPlacemark: return "Failed to get LocationPlacemark."
            case .failedToGetCLPlacemark: return "Failed to get CLPlacemark."

            //: Lokality
            case .failedToGetLokality: return "Failed to get Lokality"
            case .searchLokalityFailed: return "Search Lokality Failed."

            //: Post Related
            case .notAValidUrl: return "URL is Not Valid."
            case .noPostPreview: return "No Post News Preview available."
            case .cannotGetPreview: return "Can't get URL preview."
            case .notInWhiteList: return "Not whitelisted."
            case .failedToGetURL: return "Failed to get URL"
            case .failedToGetURLInformation: return "Failed to get URLInformation"
            case .failedToFormatDate: return "Failed to format date."
            case .failedToSavePost: return "Failed to save the Post."
            case .failedToGetPost: return "Failed to get Post(s)."

            //: File
            case .noFileAttached: return "No File Attached."
            case .fileNotFound: return "File Not Found."

            //: Log
            case .failedToSaveLog: return "Error saving log."
            }
        }

        var value: Int {
            switch self {
            case .parseError(let error): return error.code.rawValue

            case .nilValue: return 1000
            case .noInternetConnection: return 1001
            case .failedToGetSettings: return 1002

            case .failedToSave: return 1100
            case .failedToSaveUser: return 1101
            case .failedToSaveUserProfile: return 1102
            case .failedToSaveUserProfilePhoto: return 1103

            //: Object
            case .failedToCreateObject: return 1500
            case .failedToCreatePointerObject: return 1501

            //: User
            case .noUser: return 2001
            case .noUsername: return 2002
            case .userIsNotLoggedIn: return 2003
            case .loginFailed: return 2104
            case .logoutFailed: return 2105
            case .invalidCredentials: return 2106
            case .incorrectPassword: return 2107

            //: User Profile changes
            case .noProfilePhoto: return 2101
            case .noUserProfile: return 2102
            case .noUserSettings: return 2103
            case .emailIsNotVerified: return 2104
            case .emailsDoNotMatch: return 2105
            case .passwordsDoNotMatch: return 2106
            case .changePasswordFail: return 2107
            case .changeEmailFail: return 2108
            case .failedToGetUserElement: return 2109
            case .newPasswordSameAsCurrent: return 2110

            //: User Sign Up
            case .signUpFailed: return 2200
            case .invalidUsername: return 2201
            case .invalidPassword: return 2202
            case .passwordNeedsUppercase: return 2203
            case .passwordNeedsLowercase: return 2204
            case .passwordNeedsSpecialCharacter: return 2205
            case .passwordTooShort: return 2206
            case .passwordTooLong: return 2207
            case .passwordContainsSpaces: return 2208

            //: Location Codes
            case .noPlacemark: return 3001
            case .noNameData: return 3002
            case .noPlacemarkName: return 3003
            case .noPlacemarkLevel: return 3004
            case .noCoordinate: return 3005
            case .noDeviceCoordinate: return 3006
            case .noAddressEntered: return 3007
            case .searchLocationFailed: return 3008

            case .failedToBuildLocationTree: return 3100
            case .failedBuildAddressForPlacemark: return 3101
            case .failedToCreateLocation: return 3102
            case .failedToCreateLocationPlacemark: return 3103
            case .failedToGetLocation: return 3104
            case .failedToGetLocationPlacemark: return 3105
            case .failedToGetCLPlacemark: return 3106

            //: Lokality
            case .failedToGetLokality: return 3501
            case .searchLokalityFailed: return 3502


            //: Post Codes
            case .notAValidUrl: return 4001
            case .noPostPreview: return 4002
            case .cannotGetPreview: return 4003
            case .notInWhiteList: return 4004
            case .failedToGetURL: return 4005
            case .failedToGetURLInformation: return 4006
            case .failedToFormatDate: return 4007
            case .failedToSavePost: return 4008
            case .failedToGetPost: return 4009

            //: Tag Codes
            case .noTag: return 5001

            //: File
            case .noFileAttached: return 6001
            case .fileNotFound: return 6002

            //: Log
            case .failedToSaveLog: return 7001
            }
        }

        //: Title for use with Alert.
        var title: AlertTitles {
            switch self {
            case .noInternetConnection: return .uhoh
            case .invalidCredentials: return .whoops
            case .passwordNeedsUppercase: return .oops
            case .passwordNeedsLowercase: return .oops
            case .passwordNeedsSpecialCharacter: return .oops
            case .passwordTooLong: return .oops

            default:
                return .error
            }
        }

        //: Equatable
        public static func == (lhs: LokalityError.Code, rhs: LokalityError.Code) -> Bool {
            return lhs.value == rhs.value
        }

    }

}

extension LokalityError {

    // MARK: - -------------- Inits --------------
    public init(_ code: Code, message: String? = nil) {
        self.code = code

        if let message = message {
            self.message = message
        } else {
            self.message = code.description
        }
    }

    public init(_ code: ParseError.Code, message: String) {

        self.code = .parseError(.init(code: code, message: message))
        self.message = message
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            code = try values.decode(Code.self, forKey: .code)
            // otherCode = nil
        } catch {
            code = .other
            // otherCode = try values.decode(Int.self, forKey: .code)
        }
        message = try values.decode(String.self, forKey: .message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
    }

}

extension LokalityError: CustomStringConvertible {
    public var description: String {
        code.description
    }
}
