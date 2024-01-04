//
//  Tag+TagType.swift
//  Lokality
//
//  Created by Jayson Ng on 6/19/21.
//

import Foundation
import ParseSwift
import os.log

struct Tag: ParseObject, Identifiable, Codable {

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var id: String? { objectId }
    var name: String?

    var isBanned: Bool?
    var isHappeningNow: Bool?
    var isLocationTag: Bool?
    var isTopicTag: Bool?

    private var tagType: TagType?

    // var bannedBy: Pointer<ParseUser>

    //: Alias
//    var tag: String? {
//        get { name }
//        set { name = newValue }
//    }
}

// MARK: - -------------- Inits --------------
extension Tag {

    init(objectId: String) {
        self.objectId = objectId
    }

    init(_ tag: String, type: TagType.Types = .basic) {
        var acl                 = ParseACL()
        acl.publicRead          = true
        acl.publicWrite         = false
        ACL                     = acl

        self.name               = tag
        self.tagType            = TagType.tagTypes.tagType(type)

    }

}

extension Tag {

    /// - returns: A cleaned up version of the passed String array.
    func cleanTagArray(_ tagArray: [String]) -> [String] {
        var cleanedTagArray: [String] = []
        for tag in tagArray {
            cleanedTagArray.append(tag.cleanTag())
        }
        return cleanedTagArray
    }
}

// MARK: - |||||| --- Tag Type --- ||||||
struct TagType: ParseObject {

    // MARK: - -------------- Properties --------------
    var id: String? { objectId }

    //: Those are required for Object
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?

    static public var tagTypes: [TagType] = Bundle.main.decode(from: "tagTypes.json")

    enum Types: String, CaseIterable, Codable {
        case location
        case topic
        case branch
        case establishment
        case basic
    }

}

extension TagType {

    // MARK: - --------------  Inits  --------------
    init(_ type: TagType.Types = .basic) {
        self.objectId = Self.tagTypes.tagType(type).objectId
        self.name     = Self.tagTypes.tagType(type).name
    }
}

// MARK: - -------------- Foundation Extensions --------------
extension Array where Element == TagType {

    /// Convenience method for returning first(where)
    /// - Parameter type: TagType.Types
    /// - Returns: TagType matching type parameter
    func tagType(_ type: TagType.Types) -> TagType {
        self.first(where: { $0.name == type.rawValue }) ?? TagType()
    }
}

extension String {

    /// - returns: A cleaned String representing a Tag
    func cleanTag() -> String {
        let pattern = "[^A-Za-z0-9]+"
        return self.lowercased().replacingOccurrences(of: pattern, with: "", options: [.regularExpression]).trimmed()
    }

    /// Get a clean Array of Strings based on the given String separated by a ","
    /// - returns: A String array representing Tags cleaned up via cleanTag()
    func getCleanTags() -> [String]? {
        if self.trimmed() == "" {
          return nil
        } else {
            let tagArray = self.components(separatedBy: ",")
            let tags = tagArray.map({ $0.trimmed() })
            return Tag().cleanTagArray(tags)
        }
    }
}

extension Array where Element == String { 
    
    /// Get a clean Array of Strings based on the given String separated by a ","
    /// - returns: A String array representing Tags cleaned up via cleanTag()
    func getCleanTags() -> [String]? {
        
        if self.count < 1 {
          return nil
        } else {
            return Tag().cleanTagArray(self)
        }
    }
}
