//
//  LokalityCollection.swift
//  
//
//  Created by Jayson Ng on 6/22/23.
//

import Vapor
import ParseSwift

struct LokalityCollection: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let lokalityGroup = routes.grouped("lokality")
        
//        lokalityGroup.post(use: postWelcome)
//        lokalityGroup.get(use: getWelcome)

        lokalityGroup.post("get", name:"getLokality", use: getLokality)
        //lokalityGroup.post("first", name:"first", use: getLokalityFirst)
    }
}
    
extension LokalityCollection {

    enum LokalityKeys {
        case name, tag
    }
}

extension LokalityCollection {
    func getWelcome(req: Request) async throws -> String {
        return "getWelcome Hello"
    }
    
    func postWelcome(req: Request) async throws -> String {
        return "postWelcome Hello"
    }
    
    func getLokality(req: Request) async throws -> ParseHookResponse<Lokality> {
        
        if let error: ParseHookResponse<Lokality> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, LokalityParameters>.self)
        let params = parseRequest.parameters
        
        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
        }
    
        
        // Check Name or Tag
        guard let name = params.name, let tag = params.tag else {
            return ParseHookResponse(error: .init(code: .missingKey,
                                                message: "Object not sent in request."))
        }
        
        
        return ParseHookResponse(success: Lokality())
    }

    
    func getLokalityFirst(req: Request) async throws -> ParseHookResponse<GameScore> {
        
        // Note that `ParseHookResponse<GameScore>` means a "successfull"
        // response will return a "GameScore" type.
        if let error: ParseHookResponse<GameScore> = checkHeaders(req) {
            return error
        }
        var parseRequest = try req.content
            .decode(ParseHookTriggerObjectRequest<User, GameScore>.self)
        
        // If a User called the request, fetch the complete user.
        dump("parseRequest.user: \(parseRequest.user)")
        dump("parseRequest.gamescore: \(parseRequest.object)")
        
        if parseRequest.user != nil {
            //do {
            //parseRequest = try await parseRequest.hydrateUser(request: req)
            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
            
            //} catch {
            //  print("error: ParseRequest \(error)")
            //}
        }
        
        //  guard let object = parseRequest.object else {
        //      return ParseHookResponse(error: .init(code: .missingObjectId,
        //                                            message: "Object not sent in request."))
        //  }
        //  // To query using the primaryKey pass the `usePrimaryKey` option
        //  // to ther query.
        //  let scores = try await GameScore.query.findAll(options: [.usePrimaryKey])
        //  req.logger.info("Before save is being made. Showing all scores before saving new ones: \(scores)")
        return ParseHookResponse(success: GameScore())
    }
    
}


