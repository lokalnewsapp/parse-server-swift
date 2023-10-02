//
//  LocationCollection.swift
//
//
//  Created by Jayson Ng on 7/05/23.
//

import Vapor
import ParseSwift

struct LocationCollection: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let locationGroup = routes.grouped("location")
        
        locationGroup.post("create", name:"createLocationWithCenter", use: createLocationWithCenter)
        locationGroup.post("test", name:"testQuery", use: testQuery)
    }
}
    
extension LocationCollection {
    
    func testQuery(req: Request) async throws -> ParseHookResponse<[GameScore]> {
        if let error: ParseHookResponse<[GameScore]> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, FooParameters>.self)
         
        req.logger.info("parseRequest: \(parseRequest)")

        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
            parseRequest = try await parseRequest.hydrateUser(request: req)
        }
        
        //req.logger.info("parseRequest after hydrateUser:  \(parseRequest)")
        
        let options = try parseRequest.options(req)
        let scores = try await GameScore.query.findAll(options: options)
        
        return ParseHookResponse(success: scores)

    }
    
    func createLocationWithCenter(req: Request) async throws -> ParseHookResponse<Location> {
        
        if let error: ParseHookResponse<Location> = checkHeaders(req) {
            return error
        }
        
        var parseRequest = try req.content
            .decode(ParseHookFunctionRequest<User, LocationParameters>.self)
        
        // If a User called the request, fetch the complete user.
        if parseRequest.user != nil {
//            parseRequest = try await parseRequest.hydrateUser(options: [.usePrimaryKey], request: req)
            parseRequest = try await parseRequest.hydrateUser(request: req)
        }
    
        let params = parseRequest.parameters

        // Check long and lat
        guard let center = params.center else {
            return ParseHookResponse(error: .init(code: .other,
                                                message: "Center not sent in request."))
        }

        //: 2a. GetLocation based on given name if available
        if let center = params.center {
            do {
                
                let options = parseRequest.options()
                
                let location = try await LocationStore().getLocation(options: options, byName: params.name ?? "", andCenter: center)
                
                print("\n\n Found: \(location.name) tag: \(location.details?.mainTag) \n\n")
                
                return ParseHookResponse(success: location)
            } catch {
                throw LOKError(.failedToGetLocation, message: "No location found.")
            }
            
        } else {
            throw LOKError(.failedToGetLocation, message: "No device coordinates available.")
        }

       
//        do {
//            let lokality = try await Lokality.query()
//                .where("tag" == tag)
//                .first(options: [.usePrimaryKey])
//            return ParseHookResponse(success: location)
//        } catch {
//            throw error
//        }

    }
    
//    func createLocation(name: String, tag: String, areaType: LocationAreaType) async throws -> Location {
//
//        //: 1. Get currentLocation
////        do {
////            try await self.getCurrentLocation()
////        } catch {
////            throw LOKError(.failedToGetLocation)
////        }
//
//        //: 2. Get current device location
//        do {
//            //: 2a. GetLocation based on given name if available
//            if let coordinate = self.currentDeviceCoordinate {
//                let location = try await getLocation(byName: name, andCenter: ParseGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
//
//                print("\n\n Found: \(location.name) tag: \(location.details?.mainTag) \n\n")
//
//                return location
//
//            } else {
//                throw LOKError(.failedToGetLocation, message: "No device coordinates available.")
//            }
//
//        } catch {
//
//            // No Location found by name and center.
//            // Let's create one.
//            if let coordinate = self.currentDeviceCoordinate {
//
//                let clLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//
//                let clPlacemark = try await getClPlacemark(clLocation: clLocation)
//
//                let parentLocation = self.currentLocation
//
//                let address = buildAddress(for: clPlacemark, startPlacemarkLevel: .name, name: name)
//
//                print("\n\n Address of new location is: \(address) parentLocation: \(parentLocation?.fullName)\n\n")
//
//                let locationPlacemark = try await createLocationPlacemark(for: clPlacemark, address: address, name: name)
//
//                let newLocation = try await createLocation(for: locationPlacemark, placemarkLevel: .name, parent: parentLocation)
//
//                print("\n\n Should be name: \(name) tag: \(tag) \n\n")
//                print("\n\n Details name: \(newLocation.details?.name) tag: \(newLocation.details?.mainTagString) \n\n")
//
//                var foundLocationDetails = newLocation.details ?? LocationDetails()
//                print("\n\n foundLocationDetails: \(foundLocationDetails.objectId) \n\n")
//
//                foundLocationDetails.name = name
//                foundLocationDetails.mainTagString = tag
//                foundLocationDetails.areaType = areaType
//
//                let saved = try await foundLocationDetails.save()
//                print("\n\n newname: \(saved.name) tag: \(saved.mainTagString) \n\n")
//
//                return newLocation
//
//            } else {
//                throw error
//            }
//        }
//    }
//    
}


