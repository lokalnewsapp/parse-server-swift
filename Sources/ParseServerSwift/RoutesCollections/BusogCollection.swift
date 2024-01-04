//
//  BusogCollection.swift
//
//
//  Created by Jayson Ng on 12/13/23.
//

import Vapor
import ParseSwift
import CoreLocation

struct BusogCollection: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        
        let busogGroup = routes.grouped("busog")
        
        //: Testers
        busogGroup.get(use: getBusogLokalityOfTheDay)
//        busogGroup.get(use: getWelcome)

        //busogGroup.post("getByTag", name:"getBusogLokalityByTag", use: getBusogLokalityByTag)
        
    }
}
    
extension BusogCollection {

    func getBusogLokalityOfTheDay(req: Request) async throws -> String {
        return "getBusogLokalityOfTheDay - ?"
    }
    
//    func getBusogLokalityByTag(req: Request) async throws -> ParseHookResponse<BusogLokality> {
//        
//        if let error: ParseHookResponse<BusogLokality> = checkHeaders(req) {
//            return error
//        }
//        
//        var parseRequest = try req.content
//            .decode(ParseHookFunctionRequest<User, LokalityParameters>.self)
//        let params = parseRequest.parameters
//        
//        // If a User called the request, fetch the complete user.
//        if parseRequest.user != nil {
//            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
//        }
//
//        // Check Tag
//        guard let tag = params.tag else {
//            return ParseHookResponse(error: .init(code: .other,
//                                                message: "Tag not sent in request."))
//        }
//        
//        do {
//            let lokality = try await Lokality.query()
//                .where("tag" == tag)
//                .first(options: [.usePrimaryKey])
//            
//            let busogLokality = BusogLokality(lokality: lokality)
//            busogLokality.busogLokalityDetails = try? await BusogLokalityDetails.query()
//                .where("lokality" == lokality)
//                .first(options: [.usePrimaryKey])
//
//            return ParseHookResponse(success: busogLokality)
//            
//        } catch {
//            throw error
//        }
//
//    }
}
