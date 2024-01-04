// Copyright © 2020 jay.ph. All rights reserved.

import Foundation
import SwiftUI

// MARK: - --------------  ALERT Helpers  --------------
enum AlertState {
    // case profilePhotoNotSavedAlert
    case basicAlert
    case alertWithConfirm
    case destructive
}

enum AlertType {
    case error(LokalityError.Code)
    case success(LokalitySuccess.Code)
}

enum AlertTitles: String {
    case empty                              = ""

    // Error
    case error                              = "Error!"
    case somethingIsWrong                   = "Something is wrong."
    case hmmm                               = "Hmmm..."
    case uhoh                               = "Uh oh!"
    case oops                               = "Oops!"
    case whoops                             = "Whoops!"

    // Success
    case success                            = "Success!"
    case yahoo                              = "Yahoo!"
    case yehey                              = "Yehey!"
    case okay                               = "OK!"
    case congratulations                    = "Congratulations!"

    // Others
    case hey                                = "Hey!"
    case huy                                = "Huy!"
    case pssst                              = "Pssst!"
    case areYouSure                         = "Are you sure?"

    //
    case pleaseCheckYourEmail               = "Please check your email."

}
