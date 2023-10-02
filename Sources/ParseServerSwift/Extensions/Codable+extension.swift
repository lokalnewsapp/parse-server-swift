//
//  Codable+extension.swift
//  Lokality
//
//  Created by Jayson Ng on 1/19/22.
//

import Foundation
import os.log

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)).flatMap { $0 as? [String: Any] }
    }
}
