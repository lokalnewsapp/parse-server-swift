//
//  Agreement.swift
//  Lokality
//
//  Created by Jayson Ng on 7/17/21.
//

import Foundation
import ParseSwift

struct Agreement: ParseObject {

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Your custom keys.
    var id: String? { objectId }
    var version: String?
    var file: Data?
    var url: String?
    var type: String?
    var latest: Bool?

    enum Types: String, ObjectIdable, CaseIterable, CustomStringConvertible {
                
        case privacy
        case tos

        var description: String {
            switch self {
            case .privacy:
                return "privacy"
            case .tos:
                return "tos"
            }
        }
    }

}

extension Agreement {

    // MARK: - --------------  Init  --------------
    init(_ agreement: Agreement.Types) {
        //: Agreement.Types need to be extended for objectId
        self.objectId = agreement.objectId
    }
}
