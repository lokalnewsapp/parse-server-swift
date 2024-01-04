//
//  Coordinate.swift
//  Lokality (iOS)
//
//  Created by Jayson Ng on 9/23/23.
//

import Foundation
import ParseSwift

struct Coordinate: Codable, Hashable {
    let latitude, longitude: Double
    
    func toParseGeoPoint() -> ParseGeoPoint {
        return try! ParseGeoPoint(latitude: self.latitude, longitude: self.longitude)
    }
}
