//
//  Post.swift
//  Lokality (iOS)
//
//  Created by Jayson Ng on 4/4/21.
//
import Foundation
import ParseSwift
//import Carter

struct Post: ParseObject, Identifiable {

    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var title: String?
    var body: String?
    var article: Article?

    var user: User?
    var tags: [String]?
    var location: Location?
    var postType: PostType?

    var verifiedOn: Date?
    var isVerified: Bool?
    var verifiedBy: Pointer<User>?

    var displayUntil: Date?

}

extension Post {

    // MARK: - -------------- Inits ---------------
    init() async throws {

        do {
           try await ACL?.setDefaultPostACL()
        } catch let error as LOKError {
            throw error
        } catch let error as ParseError {
            throw LOKError(.parseError(error))
        }
    }

    init(sample: Bool = true) {
        self.init()
        self.objectId = "sample"
        self.title = "This is the title of the sample"
        self.body = "This is a body sample"
        // self.articleUrl = "http://google.com"
        // self.articleDate = Date()
    }

//    init(with urlPreview: URLInformation ) {
//        self.init()
//        self.title      = urlPreview.title
//        self.article    = PostNews(with: urlPreview)
//        self.body       = urlPreview.descriptionText
//
//        if urlPreview.type.rawValue == "article" {
//            self.postType = PostType(.news)
//        } else {
//            // Default postType to default
//            self.postType = PostType(.status)
//        }
//
//    }

}

extension Post: Equatable {
    static func == (left: Post, right: Post) -> Bool {
        return left.article?.id == right.article?.id
    }
}

struct PostTopic: ParseObject, Identifiable, ParseQueryScorable {

    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var score: Double?

    var name: String?
    var description: String?

    var mainTag: Tag?
    // var moderator: ParseRelation<User>
}
