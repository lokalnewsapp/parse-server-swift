//
//  LokalityParameters.swift
//
//
//  Created by Jayson Ng on 6/24/2023.
//

import ParseSwift
import Vapor
// import CoreLocation

/**
 Parameters for the Lokality Parse Hook Function.
 */
struct LokalityParameters: ParseHookParametable {
    
    var objectId: String?
    
    var name: String?
    var altNames: [String]?
    var tag: String?
    var altTags: [String]?
    
    var center: Coordinate?
    var slogan: String?
    var description: String?
    
    var lokalityType: LokalityType?
    var lokalityTypeDetails: LokalityTypeDetails?
    var lokalityCustom: LokalityCustom?

    var isActive: Bool?
    var isFeatured: Bool?
    var status: Status?
    
    var limit: Int?

}

extension LokalityParameters: Validatable {
    static func validations(_ validations: inout Validations) {
        return
    }
}
