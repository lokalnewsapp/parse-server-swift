//
//  LokalityImage.swift
//  Lokality
//
//  Created by Jayson Ng on 7/29/21.
//

import Foundation
import ParseSwift

struct LokalityImage: ParseObject, Identifiable {

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var id: String? { objectId }
    var user: Pointer<User>?
    var imageType: LokalityImageType?
    var file: ParseFile?

    var description: String?
    var name: String?
    var credit: String?

    var thumbnail100x100: ParseFile?
    var thumbnail100x150: ParseFile?

}

extension LokalityImage {

    mutating func getFile() async throws -> LokalityImage? {

        do {
            let image = try await self.fetch().fetch(includeKeys: ["file", "user", "imageType"])

            //Logger.profilePhoto.debug("Image to fetch inside DO \(image.file?.name ?? "---")")

            if image.file == nil {
                return image
            } else {
                throw LOKError(.fileNotFound)
            }

        } catch {
            //Logger.profilePhoto.error("Something went wrong while fetching Lokality Image File \(error.localizedDescription)")
            throw LOKError(.fileNotFound)
        }
    }

    // MARK: - --------------  Static Helpers  --------------
    /// Get the ProfilePhoto ParseFile
    /// - Parameter image: LokalityImage Object to get file
    /// - Returns: The Parse File of the given LokalityImage object
    static func getFile(of image: LokalityImage) async throws -> LokalityImage {

        do {
            let image = try await image.fetch().fetch(includeKeys: ["file", "user", "imageType"])

            //Logger.profilePhoto.debug("Image to fetch inside DO \(image.file?.name ?? "---")")

            if image.file != nil {
                return image
            } else {
                throw LOKError(.fileNotFound)
            }

        } catch let error as ParseError {
            //Logger.profilePhoto.error("Something went wrong while fetching Lokality Image File \(error.localizedDescription)")
            print(error)
            throw LOKError(.fileNotFound)
        }
    }

}

struct LokalityImageType: ParseObject, Identifiable {

    //: These are required for `ParseObject`.
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var id: String? { objectId }
    var name: String?
    var type: String?

    enum Types: String {
        case profilePic
        case locationPhoto
        case postPhoto
        case userPhoto
    }

}

extension LokalityImageType {
    init(type: Types) {
        self.objectId = type.objectId
    }
}

extension LokalityImageType.Types: ObjectIdable {

    var objectId: String {
        switch self {
        case .profilePic: return "c1NGBGI0M7"
        case .locationPhoto: return "M8yx2uGBGa"
        case .userPhoto: return "QobP3EZGJ5"
        case .postPhoto: return "TwCRN18pHq"
        }
    }
}
