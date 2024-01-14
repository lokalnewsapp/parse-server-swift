//
//  LokalityAgreement.swift
//  Lokality
//
//  Created by Jayson Ng on 2/6/22.
//

extension Agreement.Types {

    //: For now, we are just hardcoding the objectId of these 2 Agreement
    //: objects. Should we export to a json bundle as well like the others?
    var objectId: String {
        switch self {
        case .privacy:
            return "HAt63a8fGi"
        case .tos:
            return "pCMSHmXPhe"
        }
    }
}
