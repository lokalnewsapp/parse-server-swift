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
        routes.group("users") { group in
            group.get(":username", "hello", use: getWelcome)
            //group.get(":username", "score", use: getScore)
        }
    }
}

extension UserCollection {
    func getWelcome(request: Request) -> String {
        return "welcome"
    }
    func getScore(request: Request) -> String {
        return "score"
    }
}
