//
//  PosNews.swift
//  Lokality (iOS)
//
//  Created by Jayson Ng on 4/4/21.
//
import Foundation
import ParseSwift
//import Carter
import os.log

typealias Article = PostNews
struct PostNews: ParseObject, Identifiable {
    //: For Identifiable
    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var title: String?
    var body: String?
    var originalUrl: String?
    var url: String?
    var imageUrl: String?
    var publishDate: Date?
    var tags: [String]?
    var author: String?
    // var domain: PostNewsWhiteList?

    var center: ParseGeoPoint?
    // var articleImage:

    var isTopNewsStory: Bool?

}

//extension PostNews {
//    init(with urlInformation: URLInformation) {
//
//        title         = urlInformation.title
//        body          = urlInformation.descriptionText
//        originalUrl   = urlInformation.originalURL.absoluteString
//        url           = urlInformation.url.absoluteString
//        imageUrl      = urlInformation.imageURL?.absoluteString
//        author        = urlInformation.author
//        tags          = urlInformation.keywords?.getCleanTags()
//
//        /// See: https://nsdateformatter.com for formats
//        if let publishDate = urlInformation.publishDate {
//            self.publishDate = formatDate(for: publishDate)
//            if self.publishDate == nil {
//                // Something went wrong. This should not be nil.
//                // Add the erring date format to ArticleDateFormat
//                //Logger.post.error("Error:  \(LOKError(.failedToFormatDate))")
//            }
//        }
//
//    }
//}

extension PostNews {
    // MARK: - -------------- Methods ---------------
    /// Formats the given String representing a Date and returns a Date object.
    /// - parameters:
    ///   - publishedDate: String representing the Date to convert
    /// - returns: Converted given String to Date format. Return nil if it did not convert successfully.
    func formatDate(for publishedDate: String) -> Date? {
        let allDateFormats = ArticleDateFormat.allCases
        for dateFormat in allDateFormats {

            let isoDateFormatter = ISO8601DateFormatter()
            var dateHolder = isoDateFormatter.date(from: publishedDate)

            if dateHolder != nil {
                return dateHolder!
                // break
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = dateFormat.description

                dateHolder = dateFormatter.date(from: publishedDate)
                if dateHolder != nil {
                    // foundDateFormat = dateFormat
                    return dateHolder!
                    // break
                }
            }
        }
        return nil
    }

}

extension Article {

    enum SampleUrl: CaseIterable, CustomStringConvertible {
        case inquirer
        case gmanetwork
        case manilabulletin
        case philstar
        case cnnphilippines

        var description: String {
            switch self {
            case .inquirer:
                return "https://newsinfo.inquirer.net/1460383/pacquiao-on-roques-watusi-remark-ill-show-corruption-proof-on-my-return?test=1"
            case .gmanetwork:
                return "https://www.gmanetwork.com/news/opinion/newshardcore/790250/manix-abrera-s-news-hardcore-475/story/"
            case .manilabulletin:
                return "https://mb.com.ph/2021/07/16/govt-private-sector-receive-over-1-15-million-astrazeneca-vaccines/"
            case .philstar:
                return "https://www.philstar.com/other-sections/news-commentary/2021/07/16/2112975/necropolitics-death-and-politics-usual"
            case .cnnphilippines:
                return "https://cnnphilippines.com/news/2021/7/17/Fabian-updates-.html"
            }
        }
    }

    enum ArticleDateFormat: CaseIterable, CustomStringConvertible {

        case inquirer
        // case gmanetwork
        case ISO8601

        var description: String {
            switch self {
            case .inquirer: return "E, d MMM yyyy HH:mm:ss zzz"

                // Default to ISO8601
                // https://nsdateformatter.com
                // cases below use ISO8601

                // case .gmanetwork:
            default:
                return "yyyyMMdd'T'HHmmssZ"
            }
        }

    }
}

struct PostNewsWhiteList: ParseObject, Identifiable {
    //: For Identifiable
    var id: String? { objectId }

    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    var name: String?
    var domain: String?
    var host: String?
    var subdomains: [String]?
}
