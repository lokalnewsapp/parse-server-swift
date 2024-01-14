//
//  BusogUser+Vapor.swift
//
//
//  Created by Jayson Ng on 1/13/24.
//

import Foundation
import ParseSwift
import Vapor

extension User: Content, Validatable {

    //:: https://docs.vapor.codes/basics/validation/
    static func validations(_ validations: inout Validations) {
        
        // Validations go here.
        validations.add("email", as: String.self, is: .email)
    }
}
