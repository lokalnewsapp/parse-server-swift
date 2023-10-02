//
//  LokalityParameters.swift
//
//
//  Created by Jayson Ng on 6/24/2023.
//

import ParseSwift
import Vapor
import CoreLocation

/**
 Parameters for the Lokality Parse Hook Function.
 */
struct LokalityParameters: ParseHookParametable {
    var name: String?
    var tag: String?
    var center: Coordinate?
    var description: String?
    var limit: Int?
}

extension LokalityParameters: Validatable {
    static func validations(_ validations: inout Validations) {
        return
    }
}
