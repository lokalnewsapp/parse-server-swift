//
//  Currency.swift
//  Lokality
//
//  Created by Jayson Ng on 12/4/23.
//

import Foundation
import ParseSwift
//import os.log

struct Currency: ParseObject, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var code: String?

}
