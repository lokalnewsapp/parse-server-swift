//
//  BusogLokality.swift
//  
//
//  Created by Jayson Ng on 12/22/23.
//

import Foundation
import ParseSwift

extension Lokality {
    var busogLokalityDetails: BusogLokalityDetails? { lokalityCustom?.busogLokalityDetails  }
}

struct LokalityCustom: ParseObject, Identifiable, Equatable {

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var lokality: Pointer<Lokality>?
    var busogLokalityDetails: BusogLokalityDetails?

}

struct BusogLokalityDetails: ParseObject, Equatable {
    
    static func == (lhs: BusogLokalityDetails, rhs: BusogLokalityDetails) -> Bool {
        lhs.objectId == rhs.objectId
    }

    //: For Identifiable
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    //: Object's own properties.
    var lokality: Pointer<Lokality>?
    
    var menus: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "types", object: BusogMenu.self)
    }
    var types: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "types", object: BusogFoodType.self)
    }
    var cuisines: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "cuisines", object: BusogCuisine.self)
    }
}


struct BusogMenu: ParseObject, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var label: String?
    var sections: [String]?
    var isActive: Bool?

    var images: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "attributes", object: LokalityImage.self)
    }

    var items: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "favoriteByUsers", object: BusogFood.self)
    }

}

struct BusogFood: ParseObject, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var description: String?
    var lokality: Pointer<Lokality>?
    var weight: Int?
    var section: String?
    var attributes: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "attributes", object: BusogFoodAttributes.self)
    }
    var price: Double?
    var currency: Pointer<Currency>?
    var favoriteByUsers: ParseRelation<Self>? {
        try? ParseRelation(parent: self, key: "favoriteByUsers", object: User.self)
    }
}

struct BusogFoodAttributes: ParseObject, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var attribute: String?
    var sfIcon: String?

}

struct BusogFoodType: ParseObject, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var type: String?
    var sfIcon: String?
}

struct BusogCuisine: ParseObject, Identifiable {

    //: For Identifiable
    var id: String? { objectId }

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var cuisine: String?
    var sfIcon: String?

}
