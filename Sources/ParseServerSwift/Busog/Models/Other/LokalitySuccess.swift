//
//  LokalitySuccess.swift
//  Lokality
//
//  Created by Jayson Ng on 11/4/21.
//

import Foundation
import ParseSwift

/**
 An object with a Lokality code and message.
 */
public struct LokalitySuccess {
  /// The value representing the error from the Parse Server.
  public let code: Code
  /// The text representing the error from the Parse Server.
  public let message: String

  init(code: Code, message: String? = nil) {
    self.code = code

    if message == nil {
      self.message = code.description
    } else {
      self.message = message!
    }
  }

  public enum Code: Codable, CustomStringConvertible {
    public var description: String {
      switch self {
      case .successfullySignedUp: return "You have successfully signed up!"
      case .successfullyVerifiedEmail: return "You have successfully verified your email."
      case .successfullyChangedPassword: return "Successfully changed the password."

      case .emailVerificationSent: return "Email verification link has been sent. Please check your email."
      case .resetPasswordSent: return "A reset password link has been sent to your registered email address."

      case .foundDeviceLocation: return "Found Device Location."
      }
    }

    var title: AlertTitles {
      switch self {
      case .successfullyChangedPassword: return .yahoo
      default:
        return .success
      }
    }

    public var value: Int {
      switch self {
      case .successfullySignedUp: return 1001
      case .successfullyVerifiedEmail: return 1002
      case .successfullyChangedPassword: return 1003

      case .emailVerificationSent: return 2001
      case .resetPasswordSent: return 2002

      case .foundDeviceLocation: return 3001
      }
    }

    case successfullySignedUp
    case successfullyVerifiedEmail
    case successfullyChangedPassword

    case emailVerificationSent
    case resetPasswordSent

    //: Location
    case foundDeviceLocation
  }

}
