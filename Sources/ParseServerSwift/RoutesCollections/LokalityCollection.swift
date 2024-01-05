//
//  LokalityCollection.swift
//  
//
//  Created by Jayson Ng on 6/22/23.
//

import Vapor
import ParseSwift
//import CoreLocation

struct LokalityCollection: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let lokalityGroup = routes.grouped("lokality")
        
        //: Testers
        lokalityGroup.post(use: postWelcome)
        lokalityGroup.get(use: getWelcome)

        //:: Get Methods
        lokalityGroup.post("get", "tag", name:"getLokalityByTag", use: getLokalityByTag)
        lokalityGroup.post("get", "id", name:"getLokalityByObjectId", use: getLokalityByObjectId)
        lokalityGroup.post("get", "name", name:"getLokalityByName", use: getLokalityByName)
        lokalityGroup.post("get", "all", name:"getAllLokalities", use: getAllLokalities)
        lokalityGroup.post("get", "nearYou", name:"getLokalitiesNearYou", use: getLokalitiesNearYou)
        lokalityGroup.post("get", "random", name:"getRandomLokality", use: getRandomLokality)
        
        lokalityGroup.post("search", name:"searchLokalities", use: searchLokalities)
        
        
        //:: Create Lokality Methods
        lokalityGroup.post("create", "new", name:"createLokality", use: createLokality)
        lokalityGroup.post("delete", name:"deleteLokality", use: deleteLokality)

    }
}

extension LokalityCollection {
    
    func getLokalityByTag(req: Request) async throws -> ParseHookResponse<Lokality> {
        
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
        
        // Check Tag
        guard let tag = params.tag else {
            return ParseHookResponse(error: .init(code: .other,
                                                  message: "Tag not sent in request."))
        }
        
        let options = try parseRequest.options(req)
        
        do {
            let queries = Lokality.createLokalityTagQueries(from: tag)
            
            //: We use .find instead of .first so we can check if there are more than 1 Lokality using the same Tag and alert admin if so.
            let lokalities = try await Lokality.query(or(queries: queries))
                .includeAll()
                .find(options: options)
            
            //: Check if there's more than one result returned.
            //: If so, alert admin
            // TODO: alert admin function here
            
            //: Get the 1st result
            if let lokality = lokalities.first {
                
                //: Get LokalityCustom if it exists
                if lokality.lokalityCustom != nil {
                    try await lokality.lokalityCustom?.fetch(options: options)
                }
                
                return ParseHookResponse(success: lokality)
            } else {
                return ParseHookResponse(error: ParseError(code: .objectNotFound, message: "Lokality Not Found By Tag"))
            }
            
        } catch {
            print("Error: \(error)")
            return ParseHookResponse(error: error as! ParseError)
        }
        
    }
    
    func getLokalityByObjectId(req: Request) async throws -> ParseHookResponse<Lokality> {
        
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
        
        // Check ObjectId
        guard let objectId = params.objectId else {
            return ParseHookResponse(error: .init(code: .other,
                                                  message: "ObjectId not sent in request."))
        }
        
        let options = try parseRequest.options(req)
        
        do {
            let lokality = try await Lokality.query()
                .includeAll()
                .where("objectId" == objectId)
                .first(options: options)
            
            //: Get LokalityCustom if it exists
//            if lokality.lokalityCustom != nil {
//                try await lokality.lokalityCustom?.fetch(options: options)
//            }
            
            return ParseHookResponse(success: lokality)
            
        } catch {
            print("Error: \(error)")
            throw error
        }
        
    }
    
    
    func getLokalityByName(req: Request) async throws -> ParseHookResponse<Lokality> {
        
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
        
        // Check Name
        guard let name = params.name else {
            return ParseHookResponse(error: .init(code: .other,
                                                  message: "Name not sent in request."))
        }
        
        let options = try parseRequest.options(req)
        
        do {
            let queries = Lokality.createLokalityNameQueries(from: name)
            
            let lokality = try await Lokality.query(or(queries: queries))
                .includeAll()
                .first(options: options)
            
            //: Get LokalityCustom if it exists
            if lokality.lokalityCustom != nil {
                try await lokality.lokalityCustom?.fetch(options: options)
            }
            
            return ParseHookResponse(success: lokality)
        } catch {
            print("Error: \(error)")
            throw error
        }
        
    }
    
    
    func getRandomLokality(req: Request) async throws -> ParseHookResponse<Lokality> {
        
        if let error: ParseHookResponse<Lokality> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, LokalityParameters>.self)
        
        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
        }
        
        let options = try parseRequest.options(req)
        
        do {
            let result = try await Lokality.query()
                .where("isActive" == true)
                .findAll(options: [.usePrimaryKey])
            let lokality = result[Int.random(in: 1...result.count)]
            
            //: Get LokalityCustom if it exists
            if lokality.lokalityCustom != nil {
                try await lokality.lokalityCustom?.fetch(options: options)
            }
            
            return ParseHookResponse(success: lokality)
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
    
    func getAllLokalities(req: Request) async throws -> ParseHookResponse<[Lokality]> {
        
        if let error: ParseHookResponse<[Lokality]> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, LokalityParameters>.self)
        let params = parseRequest.parameters
        
        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
        }
        
        
        // Check Limit
        let limit = params.limit ?? 20
        
        do {
            let result = try await Lokality.query()
                .where("isActive" == true)
                .limit(limit)
                .find(options: [.usePrimaryKey])
            //let lokality = result[Int.random(in: 1...result.count)]
            return ParseHookResponse(success: result)
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
    
    func searchLokalities(req: Request) async throws -> ParseHookResponse<[Lokality]> {
        
        if let error: ParseHookResponse<[Lokality]> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, LokalityParameters>.self)
        let params = parseRequest.parameters
        
        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
        }
        
        // Check Name
        guard let name = params.name else {
            return ParseHookResponse(error: .init(code: .other,
                                                  message: "Search string not sent in request."))
        }
        
        let queries = Lokality.createLokalityNameTagQueries(from: name)
        
        do {
            let foundLokalities = try await Lokality.query(or(queries: queries))
                .where("isActive" == true)
                .includeAll()
                .find(options: [.usePrimaryKey])
            
            print("Search: Number of found Lokalities: \(foundLokalities.count)")
            return ParseHookResponse(success: foundLokalities)
            
        } catch {
            print("Error: \(error)")
            throw LOKError(.searchLokalityFailed)
        }
        
    }
    
}



extension LokalityCollection {
    
    func createLokality(req: Request) async throws -> ParseHookResponse<Lokality> {
        
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
    
        // Check Tag
        guard let name = params.name, let tag = params.tag else {
            return ParseHookResponse(error: .init(code: .other,
                                                message: "Name or Tag not sent in request."))
        }

        let options = try parseRequest.options(req)

        
        do {
            var new = Lokality()
            new.name                    = name
            new.altNames                = params.altNames
            new.tag                     = tag.cleanTag()
            new.altTags                 = params.altTags?.getCleanTags()
            new.center                  = params.center?.toParseGeoPoint()
            new.radius                  = 1
            new.slogan                  = params.slogan
            new.description             = params.description
            new.lokalityType            = params.lokalityType ?? LokalityType(.establishment)
            new.lokalityTypeDetails     = params.lokalityTypeDetails
            new.lokalityCustom          = params.lokalityCustom
            new.isActive                = true
            new.isFeatured              = false
            new.status                  = Status(.active)
            
            var ACL                     = ParseACL()
            ACL.publicRead              = true
            ACL.publicWrite             = false
            new.ACL                     = ACL
            
            new.addedBy                 = try parseRequest.user?.toPointer()
            

            try await new.save(options: options)
            
            return ParseHookResponse(success: new)
        } catch {
            print("Error: \(error)")
            throw error
        }

    }

    
    func deleteLokality(req: Request) async throws -> ParseHookResponse<Bool> {
        if let error: ParseHookResponse<Bool> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, LokalityParameters>.self)
        
        let params = parseRequest.parameters
        let options = try parseRequest.options(req)

        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
        }
    
        // Check Tag
        guard let objectId = params.objectId else {
            return ParseHookResponse(error: .init(code: .other,
                                                message: "objectId not sent in request."))
        }
        
        do {
            let lokality = try await Lokality().getById(objectId)
            print("Delete Lokality with objectId \(lokality.objectId)")
            try await lokality.delete(options: [.usePrimaryKey])
            print("Delete Lokality with objectId \(lokality.objectId)")
            return ParseHookResponse(success: true)

        } catch {
            print("Error: \(error)")
            throw error
        }
    }
}

extension LokalityCollection {

    // MARK: - --------------  For Testing  ---------------
    func getWelcome(req: Request) async throws -> String {
        return "getWelcome Hello"
    }
    
    func postWelcome(req: Request) async throws -> String {
        return "postWelcome Hello"
    }
    
    
    // MARK: - --------------  Untested for Busog  ---------------
   
    
    
    
    
    
    /// Get Locations Near You
    /// - Returns: True or False if getting the location was successful
    func getLokalitiesNearYou(req: Request) async throws -> ParseHookResponse<[Lokality?]> {
        
        if let error: ParseHookResponse<[Lokality?]> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, LokalityParameters>.self)
        let params = parseRequest.parameters
        
        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
        }
        
        // Check Center
        guard let center = params.center else {
            return ParseHookResponse(error: .init(code: .other,
                                                message: "Center not sent in request."))
        }
        
//        let center = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        var constraints = [QueryConstraint]()

        dump("Center: \(center)")
        let geoPoint = try ParseGeoPoint(latitude: center.latitude,
                                         longitude: center.longitude)
        constraints.append(contentsOf: withinKilometers(key: "center", geoPoint: geoPoint, distance: 1))
        
        do {
            let foundLokalities = try await Lokality.query(constraints)
                .where("isActive" == true)
                .limit(10)
                .includeAll()
                .find()
           
            return ParseHookResponse(success: foundLokalities)

        } catch {
            throw LOKError(.searchLocationFailed)
        }
    }
    
    
}



