//
//  LocationParameters.swift
//
//
//  Created by Jayson Ng on 6/24/2023.
//

import ParseSwift
import Vapor

/**
 Parameters for the Lokality Parse Hook Function.
 */
struct LocationParameters: ParseHookParametable {
    var name: String?
    var center: ParseGeoPoint?
//    var details: LocationDetails?
    //var long: Double?
    //var lat: Double?
}
