//
//  UserCollection.swift
//  
//
//  Created by Jayson Ng on 6/22/23.
//

import Vapor
import ParseSwift

struct UserCollection: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let usersGroup = routes.grouped("user")
        
        //: Triggers
        usersGroup.post("login", "after", object: User.self,
                        trigger: .afterLogin, use: afterLogin)
                
        //: Functions
        usersGroup.post("isAdmin", name:"isAdmin", use: isAdmin)

    }
}



// MARK: - -------------- Functions --------------
extension UserCollection {
    
    func isAdmin(req: Request) async throws -> ParseHookResponse<Bool> {
        //: TODO
        return ParseHookResponse(success: true)
    }
    
}

// MARK: - -------------- Triggers --------------
extension UserCollection {
    
    // Another Parse Hook Trigger route.
    func afterLogin(req: Request) async throws -> ParseHookResponse<Bool> {

        // Note that `ParseHookResponse<Bool>` means a "successful"
        // response will return a "Bool" type. Bool is the standard response with
        // a "true" response meaning everything is okay or continue.
        if let error: ParseHookResponse<Bool> = checkHeaders(req) {
            return error
        }
        let parseRequest = try req.content
            .decode(ParseHookTriggerObjectRequest<User, User>.self)
        
        let user = parseRequest.user
        let options = try parseRequest.options(req)
        
        let userObject = try await user?.fetch(options: options)
        
//        //: Check that every user has complete UserElements
//        for element in User.UserElements.allCases {
//            //: TODO
//            if element.value == nil {
//                
//            }
//        }
        
        req.logger.info("A user has logged in: \(userObject)")
        return ParseHookResponse(success: true)
    }
    
}
