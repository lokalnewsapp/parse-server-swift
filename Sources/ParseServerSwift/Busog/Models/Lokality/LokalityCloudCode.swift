//
//  LokalityCloudCode.swift
//  Lokality
//
//  Created by Jayson Ng on 9/21/23.
//

import Foundation
import ParseSwift

// MARK: - --------------  Parse Server Swift  --------------
struct GetLokalityByTag: ParseCloudable {

    //: Return type of your Cloud Function
    typealias ReturnType = Lokality

    //: These are required by `ParseCloudable`
    var functionJobName: String = "getLokalityByTag"

    //: Parameters
    var tag: String?

}

struct GetLokalityByObjectId: ParseCloudable {

    typealias ReturnType = Lokality
    var functionJobName: String = "getLokalityByObjectId"

    //: Parameters
    var objectId: String?

}

struct GetLokalityByName: ParseCloudable {

    typealias ReturnType = Lokality
    var functionJobName: String = "getLokalityByName"

    //: Parameters
    var name: String?

}

struct GetRandomLokality: ParseCloudable {

    typealias ReturnType = Lokality
    var functionJobName: String = "getRandomLokality"

}

struct GetAllLokalities: ParseCloudable {

    typealias ReturnType = [Lokality]
    var functionJobName: String = "getAllLokalities"

    //: Parameters
    var limit: Int?

}

struct SearchLokalities: ParseCloudable {

    typealias ReturnType = [Lokality]
    var functionJobName: String = "searchLokalities"

    //: Parameters
    var name: String?

}

struct GetLokalitiesNearYou: ParseCloudable {

    typealias ReturnType = [Lokality]
    var functionJobName: String = "getLokalitiesNearYou"

    //: Parameters
    var center: Coordinate?

}

struct CreateLokality: ParseCloudable {

    typealias ReturnType = Lokality
    var functionJobName: String = "createLokality"

    //: Parameters
    var name: String?
    var altNames: [String]?
    var tag: String?
    var altTags: [String]?

    var center: ParseGeoPoint?
    var radius: Int?
    var slogan: String?
    var description: String?

    var socials: LokalitySocials?

    var lokalityType: LokalityType?
    var lokalityTypeDetails: LokalityTypeDetails?
    var isActive: Bool?
    var isFeatured: Bool?
    var status: Status?
    var ACL: ParseACL?

}

struct DeleteLokality: ParseCloudable {
    
    typealias ReturnType = Bool
    var functionJobName: String = "deleteLokality"
    
    var objectId: String?
}
