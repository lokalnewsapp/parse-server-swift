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
        usersGroup.post("login", "after",
                        object: User.self,
                        trigger: .afterLogin,
                        use: afterLogin
        )
                
    }
}

extension Data {
    var prettyString: NSString? {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) ?? nil
    }
}

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
        
        let userObject = try await User.query("objectId" == user?.objectId).includeAll().first(options: options)
        
        req.logger.info("A user has logged in: \(userObject)")
//        req.logger.info("A user has logged in: \(userObject.logable)")
        return ParseHookResponse(success: true)
    }
    
}
