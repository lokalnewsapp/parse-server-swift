//
//  Status.swift
//  
//
//  Created by Jayson Ng on 12/13/23.
//

import Foundation
import ParseSwift
import Vapor

struct Status: ParseObject {

    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var type: String?
    var description: String?
    var level: Int?
    var note: String?

    enum Types: String, CaseIterable {
        case unknown
        case active
        case inactive
        case flagged
        case underReview
        case banned
        case forDeletion
        case open
        case closed
        case permanentlyClosed
        case moved
        case temporarilyClosed
        case underRenovation
    }

}

extension Status {
    init(_ type: Types = .unknown) {
        let typeObject      = Self.jsonfile.status(type)
        self.objectId       = typeObject.objectId
        self.name           = typeObject.name
        self.description    = typeObject.description
        self.level          = typeObject.level
    }
}

extension Array where Element == Status {

    // MARK: - --------------  Array Extension  --------------

    /// Convenience method for returning first(where)
    /// - Parameter type: LokalityLogType.Types
    /// - Returns: LokalityLogType matching type parameter
    func status(_ type: Status.Types) -> Status {
        self.first(where: { $0.type == type.rawValue }) ?? Status(.unknown)
    }

}

extension Status: JSONable {
    
    // MARK: - --------------  Static Properties  --------------
    static public var jsonfile: [Status] {
        // let directory = DirectoryConfiguration.detect()
        let filesDirectory = "Sources/ParseServerSwift/Busog/Files"
        let data = try! Data(contentsOf:
                                URL(fileURLWithPath: filesDirectory, isDirectory: true)
                                .appendingPathComponent("statuses.json", isDirectory: false)
        )
        let decoder = JSONDecoder()
        
        return try! decoder.decode([Status].self, from: data)
    }
}
