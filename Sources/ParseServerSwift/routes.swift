import Vapor
import ParseSwift

// swiftlint:disable:next cyclomatic_complexity function_body_length
func routes(_ app: Application) throws {
    
    let env = try Environment.detect()
    print("Environment: \(env.name)")

    do {
        try app.register(collection: BusogCollection())
        //try app.register(collection: LocationCollection())
        try app.register(collection: UserCollection())
        try app.register(collection: LokalityCollection())
    } catch {
        print(error)
    }
    
}
