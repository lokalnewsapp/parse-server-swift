//
//  PostType.swift
//  Lokality (iOS)
//
//  Created by Jayson Ng on 4/4/21.
//

/*
 The model for a PostType.
 */

import Foundation
import ParseSwift

struct PostType: ParseObject, Identifiable {
    //: For Identifiable
    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var type: String?

    // ID's straight from database.
    enum Types: String, CaseIterable, CustomStringConvertible {

        case info
        case alert
        case emergency

        case news
        case text
        case photo
        case status

        var description: String {
            return self.objectId
        }

        var objectId: String {
            switch self {
            case .info: return "B0neKNx6Zd"
            case .alert: return "NlfkMaOEUT"
            case .emergency: return "TpRXgv9qsK"
            case .news: return "XIGYi4n1r8"
            case .text: return "IBZhEbaw7L"
            case .photo: return "BpvII8wTnB"
            case .status: return "CxZEDB0B3O"
            }
        }

    }

    init() {  }

    init(_ type: Types) {
        self.objectId = type.objectId
    }
}
