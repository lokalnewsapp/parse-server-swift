//
//  LokalityCollection.swift
//  
//
//  Created by Jayson Ng on 6/22/23.
//

import Vapor
import ParseSwift
import CoreLocation

struct LokalityCollection: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let lokalityGroup = routes.grouped("lokality")
        
        //: Testers
        lokalityGroup.post(use: postWelcome)
        lokalityGroup.get(use: getWelcome)

        lokalityGroup.post("getByTag", name:"getLokalityByTag", use: getLokalityByTag)
        lokalityGroup.post("getByName", name:"getLokalityByName", use: getLokalityByName)
        lokalityGroup.post("getAll", name:"getAllLokalities", use: getAllLokalities)
        lokalityGroup.post("random", name:"getRandomLokality", use: getRandomLokality)
        lokalityGroup.post("search", name:"searchLokalities", use: searchLokalities)
        lokalityGroup.post("getNearYou", name:"getLokalitiesNearYou", use: getLokalitiesNearYou)
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
        
        do {
            let lokality = try await Lokality.query()
                .where("tag" == tag)
                .first(options: [.usePrimaryKey])
            return ParseHookResponse(success: lokality)
        } catch {
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
        
        do {
            let lokality = try await Lokality.query()
                .where("name" == name)
                .first(options: [.usePrimaryKey])
            return ParseHookResponse(success: lokality)
        } catch {
            throw error
        }

    }

    
    func getRandomLokality(req: Request) async throws -> ParseHookResponse<Lokality> {
        
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
    
        do {
            let result = try await Lokality.query()
                .findAll(options: [.usePrimaryKey])
            let lokality = result[Int.random(in: 1...result.count)]
            return ParseHookResponse(success: lokality)
        } catch {
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
                .find(options: [.usePrimaryKey])
            //let lokality = result[Int.random(in: 1...result.count)]
            return ParseHookResponse(success: result)
        } catch {
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
        // Clean up search string
        let searchString = name.trimmed()

        // We constrain the search to name, altNames, and mainTagString fields
        let constraints = matchesRegex(key: "name", regex: searchString)
        let query1 = Lokality.query(constraints)
        let constraints2 = matchesRegex(key: "altNames", regex: searchString, modifiers: "i")
        let query2 = Lokality.query(constraints2)
        let constraints3 = matchesRegex(key: "tag", regex: searchString.replacingOccurrences(of: " ", with: ""), modifiers: "i")
        let query3 = Lokality.query(constraints3)
        let constraints4 = matchesRegex(key: "altTags", regex: searchString.replacingOccurrences(of: " ", with: ""), modifiers: "i")
        let query4 = Lokality.query(constraints4)

//        let mainQuery = Lokality.query(or(queries: [query1, query2, query3, query4]))
//            .where("active" == true)
//            .includeAll()
//            .find()

        do {
            let foundLokalities = try await Lokality.query(or(queries: [query1, query2, query3, query4]))
                .where("isActive" == true)
                .includeAll()
                .find(options: [.usePrimaryKey])
            
//            let foundLocations = try await mainQuery.limit(20).includeAll().find()
            print("Number of found Lokalities: \(foundLokalities.count)")
           
            return ParseHookResponse(success: foundLokalities)

        } catch {
            print(error)
            throw LOKError(.searchLokalityFailed)
        }
       
    }
    
    
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
            let query = Lokality.query(constraints).where("isActive" == true)
            let foundLokalities = try await query.limit(10).includeAll().find()
           
            return ParseHookResponse(success: foundLokalities)

        } catch {
            throw LOKError(.searchLocationFailed)
        }
    }
    
    
}


