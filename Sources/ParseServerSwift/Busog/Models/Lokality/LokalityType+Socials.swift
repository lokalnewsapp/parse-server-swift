//
//  LokalityType+LokalityTypeDetails.swift
//  Lokality
//
//  Created by Jayson Ng on 9/21/23.
//

import Foundation
import ParseSwift

struct LokalityType: ParseObject, Identifiable {
    
    var id: String? { objectId }
    
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var name: String?
    var type: String?
    
    enum Types: String, ObjectIdable {
        
        case group
        case establishment
        case area
        
        var objectId: String {
            switch self {
            case .group: return "tIPhLSXbHG"
            case .area: return "pLavwGZ9Tv"
            case .establishment: return "pflsRChRSJ"
            }
        }
        
        var name: String {
            switch self {
            case .group: return "Group"
            case .area: return "Area"
            case .establishment: return "Establishment"
            }
        }
    }
}

extension LokalityType {
    
    // MARK: - --------------  Inits  --------------
    init(_ type: Types = .establishment) {
        self.objectId = type.objectId
        self.name     = type.name
        self.type     = type.rawValue
    }
}


struct LokalityTypeDetails: ParseObject, Identifiable {
        
    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var type: String?
    var description: String?
    var lokalityType: LokalityType?
    var parent: Pointer<LokalityTypeDetails>?
    
    static public var types = Bundle.main.decode([LokalityTypeDetails].self, from: "lokalityTypeDetails.json")

    enum Types: String, CaseIterable, ObjectIdable {

        //: Group
        case friends

        //: Area
        case foodDistrict
        case shoppingDistrict
        case residences
        case businessDistrict
        case touristArea
        
        //: Establishments
        case educationalEstablishment
        case foodEstablishment
        
        var objectId: String {
            switch self {
            case .friends: return "4tEmwlnZq1"
            case .foodDistrict: return "hasTciGmtE"
            case .shoppingDistrict: return "goeJ1UZAY8"
            case .residences: return "GA171xZzRM"
            case .businessDistrict: return "NnJ9y5EKMa"
            case .touristArea: return "Jk3rF9PDUI"
            case .educationalEstablishment: return "Q1vB7h2ls9"
            case .foodEstablishment: return "bgMlO1O6AZ"
            }
        }
        
        //: Food Establishment Types
        enum Food: String, CaseIterable, ObjectIdable {
            case fastfood
            case bar
            case diner
            
            var objectId: String {
                switch self {
                case .fastfood: return "kEuHM8X8mc"
                case .bar: return "xKbNbIRBl7"
                case .diner: return "gHnBzn32cZ"
                }
            }
        }
    }
}

extension LokalityTypeDetails {
    
    // MARK: - --------------  Inits  --------------
    init(_ type: Types = .foodEstablishment) {
        let typeDetailObject        = Self.types.typeDetail(type)
        self.objectId               = typeDetailObject.objectId
        self.name                   = typeDetailObject.name
        self.type                   = typeDetailObject.type
        self.description            = typeDetailObject.description
        self.lokalityType           = typeDetailObject.lokalityType
        self.parent                 = typeDetailObject.parent
    }
    
    init(_ type: Types.Food = .fastfood) {
        let typeDetailObject        = Self.types.typeDetail(type)
        self.objectId               = typeDetailObject.objectId
        self.name                   = typeDetailObject.name
        self.type                   = typeDetailObject.type
        self.description            = typeDetailObject.description
        self.lokalityType           = typeDetailObject.lokalityType
        self.parent                 = typeDetailObject.parent
    }
}

extension Array where Element == LokalityTypeDetails {

    // MARK: - --------------  Array Extension  --------------

    /// Convenience method for returning first(where)
    /// - Parameter type: LokalityLogType.Types
    /// - Returns: LokalityLogType matching type parameter
    func typeDetail(_ type: LokalityTypeDetails.Types) -> LokalityTypeDetails {
        self.first(where: { $0.type == type.rawValue }) ?? LokalityTypeDetails()
    }
    
    func typeDetail(_ type: LokalityTypeDetails.Types.Food) -> LokalityTypeDetails {
        self.first(where: { $0.type == type.rawValue }) ?? LokalityTypeDetails()
    }

}


struct LokalitySocials: ParseObject, Identifiable, Equatable {
    //: For Identifiable
    var id: String? { objectId }
    
    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    var lokality: Pointer<Lokality>?

    var facebook: String?
    var instagram: String?
    var tiktok: String?
    var twitterx: String?
    var webpage: String?

}
