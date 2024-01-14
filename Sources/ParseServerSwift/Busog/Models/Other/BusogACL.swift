//
//  BusogACL.swift
//  Lokality (iOS)
//
//  Created by Jayson Ng on 1/14/24.
//

import Foundation
import ParseSwift

extension ParseACL {
    
    /// Initializes then sets default ACL for Posts
    mutating func setDefaultPostACL() async throws {
        do {
            let user = try await User.current()

            self                    = ParseACL()
            self.publicRead         = true
            self.publicWrite        = false
            self.setWriteAccess(user: user, value: true)
            self.setReadAccess(user: user, value: true)

        } catch let error as ParseError {
            throw LOKError(.parseError(error))
        }
    }

}
